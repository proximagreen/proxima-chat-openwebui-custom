FROM ghcr.io/open-webui/open-webui:main

# --- Proxima Chat branding ---

# Static assets (logos, favicons, PWA icons, CSS)
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

# Also overlay on the built static path
COPY assets/custom.css /app/backend/static/static/custom.css

# Patch env.py: remove "(Open WebUI)" suffix, set default name to "Proxima Chat"
RUN sed -i \
    -e 's/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Proxima Chat")/' \
    -e '/if WEBUI_NAME != "Open WebUI":/d' \
    -e '/WEBUI_NAME += " (Open WebUI)"/d' \
    -e 's|WEBUI_FAVICON_URL = "https://openwebui.com/favicon.png"|WEBUI_FAVICON_URL = "/static/favicon.png"|' \
    /app/backend/open_webui/env.py

ENV WEBUI_NAME="Proxima Chat"
