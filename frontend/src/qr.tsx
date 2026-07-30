// QR generation (the attendee's ticket) and scanning (the door). Generation
// uses the `qrcode` package; scanning decodes camera frames with `jsqr` (pure
// JS, works in every browser with a camera, so no BarcodeDetector support
// matrix to worry about).
import { useEffect, useRef, useState } from 'react'
import QRCode from 'qrcode'
import jsQR from 'jsqr'

// High-contrast black-on-white with a quiet zone, wrapped in a white pad so it
// scans in either theme (a themed QR would fail readers in dark mode).
export function QrCode({ text, size = 208 }: { text: string; size?: number }) {
  const ref = useRef<HTMLCanvasElement>(null)
  const [err, setErr] = useState<string | null>(null)

  useEffect(() => {
    const canvas = ref.current
    if (!canvas) return
    QRCode.toCanvas(canvas, text, { width: size, margin: 2 }).catch((e: unknown) =>
      setErr(e instanceof Error ? e.message : 'QR render failed'),
    )
  }, [text, size])

  if (err) return <p className="field-err">Could not render QR: {err}</p>
  return (
    <div style={{ background: '#fff', padding: 8, borderRadius: 8, display: 'inline-block', lineHeight: 0 }}>
      <canvas ref={ref} width={size} height={size} />
    </div>
  )
}

// Live camera scanner. Calls onResult once with the decoded string, then the
// parent is expected to unmount this component (which stops the camera).
export function QrScanner({ onResult, onCancel }: { onResult: (text: string) => void; onCancel: () => void }) {
  const videoRef = useRef<HTMLVideoElement>(null)
  const resultRef = useRef(onResult)
  resultRef.current = onResult
  const [err, setErr] = useState<string | null>(null)

  useEffect(() => {
    let stream: MediaStream | null = null
    let raf = 0
    let done = false
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d', { willReadFrequently: true })

    function scan() {
      if (done) return
      const v = videoRef.current
      if (v && v.readyState >= v.HAVE_ENOUGH_DATA && ctx && v.videoWidth > 0) {
        canvas.width = v.videoWidth
        canvas.height = v.videoHeight
        ctx.drawImage(v, 0, 0, canvas.width, canvas.height)
        const img = ctx.getImageData(0, 0, canvas.width, canvas.height)
        const code = jsQR(img.data, img.width, img.height, { inversionAttempts: 'dontInvert' })
        if (code && code.data) {
          done = true
          resultRef.current(code.data)
          return
        }
      }
      raf = requestAnimationFrame(scan)
    }

    // mediaDevices is undefined outside a secure context (any non-localhost
    // HTTP origin). Guard explicitly: an optional chain here would swallow the
    // whole promise, so the catch below would never run and no error UI would
    // show - just a dead black video box.
    if (!navigator.mediaDevices) {
      setErr('camera needs https or localhost')
      return
    }
    navigator.mediaDevices
      .getUserMedia({ video: { facingMode: 'environment' } })
      .then((s) => {
        // Unmounted while the permission prompt was open: cleanup already ran
        // with stream still null and stopped nothing, so stop these tracks
        // here or the camera stays on until a page reload.
        if (done) {
          s.getTracks().forEach((t) => t.stop())
          return
        }
        stream = s
        const v = videoRef.current
        if (!v) return
        v.srcObject = s
        return v.play()
      })
      .then(() => scan())
      .catch((e: unknown) => setErr(e instanceof Error ? e.message : 'Camera unavailable'))

    return () => {
      done = true
      cancelAnimationFrame(raf)
      stream?.getTracks().forEach((t) => t.stop())
    }
  }, [])

  return (
    <div className="scanner">
      {err ? (
        <p className="field-err">Camera: {err}. Paste the ticket text instead.</p>
      ) : (
        <video ref={videoRef} playsInline muted className="scanner-video" />
      )}
      <button type="button" className="ghost sm" onClick={onCancel}>
        Cancel scan
      </button>
    </div>
  )
}
