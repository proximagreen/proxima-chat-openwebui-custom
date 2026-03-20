FROM ghcr.io/open-webui/open-webui:main

# ============================================================
#  PROXIMA CHAT — Branding Layer
#  Strategy: static files + CSS only (no JS patching)
#  Video: injected via safe sed append before </body>
# ============================================================

# --- Favicons & Logos ---
COPY assets/favicon.png         /app/backend/open_webui/static/favicon.png
COPY assets/favicon-dark.png    /app/backend/open_webui/static/favicon-dark.png
COPY assets/favicon.svg         /app/backend/open_webui/static/favicon.svg
COPY assets/favicon.ico         /app/backend/open_webui/static/favicon.ico
COPY assets/favicon-96x96.png   /app/backend/open_webui/static/favicon-96x96.png
COPY assets/logo.png            /app/backend/open_webui/static/logo.png
COPY assets/splash.png          /app/backend/open_webui/static/splash.png
COPY assets/splash-dark.png     /app/backend/open_webui/static/splash-dark.png
COPY assets/apple-touch-icon.png          /app/backend/open_webui/static/apple-touch-icon.png
COPY assets/web-app-manifest-192x192.png  /app/backend/open_webui/static/web-app-manifest-192x192.png
COPY assets/web-app-manifest-512x512.png  /app/backend/open_webui/static/web-app-manifest-512x512.png
COPY assets/site.webmanifest    /app/backend/open_webui/static/site.webmanifest
COPY assets/custom.css          /app/backend/open_webui/static/custom.css

# Frontend build copies
COPY assets/favicon.png         /app/build/static/favicon.png
COPY assets/favicon-dark.png    /app/build/static/favicon-dark.png
COPY assets/favicon.svg         /app/build/static/favicon.svg
COPY assets/favicon.ico         /app/build/static/favicon.ico
COPY assets/favicon-96x96.png   /app/build/static/favicon-96x96.png
COPY assets/logo.png            /app/build/static/logo.png
COPY assets/splash.png          /app/build/static/splash.png
COPY assets/splash-dark.png     /app/build/static/splash-dark.png
COPY assets/apple-touch-icon.png          /app/build/static/apple-touch-icon.png
COPY assets/web-app-manifest-192x192.png  /app/build/static/web-app-manifest-192x192.png
COPY assets/web-app-manifest-512x512.png  /app/build/static/web-app-manifest-512x512.png
COPY assets/site.webmanifest    /app/build/static/site.webmanifest
COPY assets/custom.css          /app/build/static/custom.css
COPY assets/favicon.png         /app/build/favicon.png

# --- SVG Logos (auth page, served as static) ---
COPY assets/logo-auth.svg       /app/backend/open_webui/static/logo-auth.svg
COPY assets/logo-auth.svg       /app/build/static/logo-auth.svg
COPY assets/logo-auth-white.svg /app/backend/open_webui/static/logo-auth-white.svg
COPY assets/logo-auth-white.svg /app/build/static/logo-auth-white.svg

# --- PNG Logo fallback ---
COPY assets/proxima-logo.png    /app/backend/open_webui/static/proxima-logo.png
COPY assets/proxima-logo.png    /app/build/static/proxima-logo.png

# --- Video Background ---
COPY assets/Video_ecologique_Prete.mp4 /app/backend/open_webui/static/proxima-bg.mp4
COPY assets/Video_ecologique_Prete.mp4 /app/build/static/proxima-bg.mp4

# --- Replace slideshow images with transparent pixel ---
COPY assets/transparent.png /app/build/static/transparent.png
RUN find /app/build/assets/images/ -type f \( -name "*.jpg" -o -name "*.png" \) -exec cp /app/build/static/transparent.png {} \; 2>/dev/null || true

# --- Inject video + rotating headlines before </body> ---
COPY assets/inject-auth.html /tmp/inject-auth.html
RUN sed -i '/<\/body>/{ r /tmp/inject-auth.html' -e '}' /app/build/index.html

# --- Patch env.py (backend branding) ---
RUN sed -i \
    -e 's/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Proxima Chat")/' \
    -e '/if WEBUI_NAME != "Open WebUI":/d' \
    -e '/WEBUI_NAME += " (Open WebUI)"/d' \
    -e 's|WEBUI_FAVICON_URL = "https://openwebui.com/favicon.png"|WEBUI_FAVICON_URL = "/static/favicon.png"|' \
    /app/backend/open_webui/env.py

ENV WEBUI_NAME="Proxima Chat"
