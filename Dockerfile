FROM ghcr.io/open-webui/open-webui:main

# --- Proxima Chat branding ---

# 1. Backend static
COPY assets/ /app/backend/open_webui/static/

# 2. Frontend built static
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
COPY assets/logo-auth.svg /app/build/static/logo-auth.svg
COPY assets/logo-auth.svg /app/backend/open_webui/static/logo-auth.svg
COPY assets/logo-auth-white.svg /app/build/static/logo-auth-white.svg
COPY assets/logo-auth-white.svg /app/backend/open_webui/static/logo-auth-white.svg

# 3. Build root
COPY assets/favicon.png /app/build/favicon.png

# 4. Background video for onboarding page
COPY assets/Video_ecologique_Prete.mp4 /app/backend/open_webui/static/proxima-bg.mp4
COPY assets/Video_ecologique_Prete.mp4 /app/build/static/proxima-bg.mp4

# 5. Entrypoint script (patches JS text + injects video at startup)
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Patch env.py: remove "(Open WebUI)" suffix, default to "Proxima Chat"
RUN sed -i \
    -e 's/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Proxima Chat")/' \
    -e '/if WEBUI_NAME != "Open WebUI":/d' \
    -e '/WEBUI_NAME += " (Open WebUI)"/d' \
    -e 's|WEBUI_FAVICON_URL = "https://openwebui.com/favicon.png"|WEBUI_FAVICON_URL = "/static/favicon.png"|' \
    /app/backend/open_webui/env.py

ENV WEBUI_NAME="Proxima Chat"

ENTRYPOINT ["/app/entrypoint.sh"]
