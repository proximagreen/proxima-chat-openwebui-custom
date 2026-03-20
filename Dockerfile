FROM ghcr.io/open-webui/open-webui:main

# --- Proxima Chat branding (safe: static files only, no JS patching) ---

# Branded favicons, logos, splash, manifest, CSS
COPY assets/favicon.png /app/backend/open_webui/static/favicon.png
COPY assets/favicon-dark.png /app/backend/open_webui/static/favicon-dark.png
COPY assets/favicon.svg /app/backend/open_webui/static/favicon.svg
COPY assets/favicon.ico /app/backend/open_webui/static/favicon.ico
COPY assets/favicon-96x96.png /app/backend/open_webui/static/favicon-96x96.png
COPY assets/logo.png /app/backend/open_webui/static/logo.png
COPY assets/splash.png /app/backend/open_webui/static/splash.png
COPY assets/splash-dark.png /app/backend/open_webui/static/splash-dark.png
COPY assets/apple-touch-icon.png /app/backend/open_webui/static/apple-touch-icon.png
COPY assets/web-app-manifest-192x192.png /app/backend/open_webui/static/web-app-manifest-192x192.png
COPY assets/web-app-manifest-512x512.png /app/backend/open_webui/static/web-app-manifest-512x512.png
COPY assets/site.webmanifest /app/backend/open_webui/static/site.webmanifest
COPY assets/custom.css /app/backend/open_webui/static/custom.css

# Same files in frontend build path
COPY assets/favicon.png /app/build/static/favicon.png
COPY assets/favicon-dark.png /app/build/static/favicon-dark.png
COPY assets/favicon.svg /app/build/static/favicon.svg
COPY assets/favicon.ico /app/build/static/favicon.ico
COPY assets/favicon-96x96.png /app/build/static/favicon-96x96.png
COPY assets/logo.png /app/build/static/logo.png
COPY assets/splash.png /app/build/static/splash.png
COPY assets/splash-dark.png /app/build/static/splash-dark.png
COPY assets/apple-touch-icon.png /app/build/static/apple-touch-icon.png
COPY assets/web-app-manifest-192x192.png /app/build/static/web-app-manifest-192x192.png
COPY assets/web-app-manifest-512x512.png /app/build/static/web-app-manifest-512x512.png
COPY assets/site.webmanifest /app/build/static/site.webmanifest
COPY assets/custom.css /app/build/static/custom.css
COPY assets/favicon.png /app/build/favicon.png

# Proxima horizontal logo for auth page (served as static file)
COPY assets/proxima-logo.png /app/backend/open_webui/static/proxima-logo.png
COPY assets/proxima-logo.png /app/build/static/proxima-logo.png

# Video background
COPY assets/Video_ecologique_Prete.mp4 /app/backend/open_webui/static/proxima-bg.mp4
COPY assets/Video_ecologique_Prete.mp4 /app/build/static/proxima-bg.mp4

# Remove slideshow images
RUN rm -f /app/build/assets/images/adam.jpg \
          /app/build/assets/images/galaxy.jpg \
          /app/build/assets/images/earth.jpg \
          /app/build/assets/images/space.jpg

# Patch env.py only (safe, backend only)
RUN sed -i \
    -e 's/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Proxima Chat")/' \
    -e '/if WEBUI_NAME != "Open WebUI":/d' \
    -e '/WEBUI_NAME += " (Open WebUI)"/d' \
    -e 's|WEBUI_FAVICON_URL = "https://openwebui.com/favicon.png"|WEBUI_FAVICON_URL = "/static/favicon.png"|' \
    /app/backend/open_webui/env.py

ENV WEBUI_NAME="Proxima Chat"
