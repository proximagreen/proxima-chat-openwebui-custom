FROM ghcr.io/open-webui/open-webui:main

# --- Proxima Chat branding ---

# 1. Copy all branded static assets (favicon, logo, CSS, manifest, etc.)
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

# 2. Same for /app/build/static/ (frontend serves from here)
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

# 3. Build root favicon
COPY assets/favicon.png /app/build/favicon.png

# 4. Kill slideshow images — replace with transparent pixel
COPY assets/transparent.png /app/build/assets/images/adam.jpg
COPY assets/transparent.png /app/build/assets/images/galaxy.jpg
COPY assets/transparent.png /app/build/assets/images/earth.jpg
COPY assets/transparent.png /app/build/assets/images/space.jpg

# 5. Background video
COPY assets/Video_ecologique_Prete.mp4 /app/backend/open_webui/static/proxima-bg.mp4
COPY assets/Video_ecologique_Prete.mp4 /app/build/static/proxima-bg.mp4

# 6. Patch env.py at build time
RUN sed -i \
    -e 's/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Open WebUI")/WEBUI_NAME = os.environ.get("WEBUI_NAME", "Proxima Chat")/' \
    -e '/if WEBUI_NAME != "Open WebUI":/d' \
    -e '/WEBUI_NAME += " (Open WebUI)"/d' \
    -e 's|WEBUI_FAVICON_URL = "https://openwebui.com/favicon.png"|WEBUI_FAVICON_URL = "/static/favicon.png"|' \
    /app/backend/open_webui/env.py

# 7. Patch auth page JS at build time (replace slideshow, text, logo)
RUN AUTH_JS=$(grep -rl "Explore the cosmos" /app/build/_app/immutable/nodes/ 2>/dev/null | head -1) && \
    if [ -n "$AUTH_JS" ]; then \
        # Replace slideshow image URLs with transparent pixel
        sed -i 's|`${M}/assets/images/adam.jpg`,`${M}/assets/images/galaxy.jpg`,`${M}/assets/images/earth.jpg`,`${M}/assets/images/space.jpg`|`data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7`|' "$AUTH_JS" && \
        # Replace favicon.png with favicon-dark.png (our Proxima horizontal logo)
        sed -i 's|/static/favicon.png|/static/favicon-dark.png|g' "$AUTH_JS" && \
        echo "Auth JS patched: $AUTH_JS"; \
    fi

# 8. Inject video into index.html at build time
RUN sed -i 's|<body data-sveltekit-preload-data="hover">|<body data-sveltekit-preload-data="hover"><div id="proxima-video-bg"><video autoplay muted loop playsinline><source src="/static/proxima-bg.mp4" type="video/mp4"></video></div>|' /app/build/index.html

ENV WEBUI_NAME="Proxima Chat"
