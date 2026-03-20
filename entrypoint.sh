#!/bin/bash
# Proxima Chat — Patch branding at startup
# Patches are applied at runtime because JS filenames change between versions

echo "[Proxima] Applying branding patches..."

# --- 1. Inject video background into index.html ---
INDEX="/app/build/index.html"
if [ -f "$INDEX" ] && ! grep -q "proxima-video-bg" "$INDEX"; then
    echo "[Proxima] Injecting video background"
    sed -i 's|<body data-sveltekit-preload-data="hover">|<body data-sveltekit-preload-data="hover"><div id="proxima-video-bg"><video autoplay muted loop playsinline><source src="/static/proxima-bg.mp4" type="video/mp4"></video></div>|' "$INDEX"
fi

# --- 2. Find the auth page JS (node 47 or similar) ---
AUTH_JS=$(grep -rl "Explore the cosmos" /app/build/_app/immutable/nodes/ 2>/dev/null | head -1)

if [ -n "$AUTH_JS" ]; then
    echo "[Proxima] Patching auth page: $AUTH_JS"

    # 2a. Replace slideshow images with single transparent pixel (video will show through)
    sed -i 's|`${M}/assets/images/adam.jpg`,`${M}/assets/images/galaxy.jpg`,`${M}/assets/images/earth.jpg`,`${M}/assets/images/space.jpg`|`data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7`|' "$AUTH_JS"

    # 2b. Replace marquee text
    sed -i 's|a().t("Explore the cosmos"),a().t("Unlock mysteries"),a().t("Chart new frontiers"),a().t("Dive into knowledge"),a().t("Discover wonders"),a().t("Ignite curiosity"),a().t("Forge new paths"),a().t("Unravel secrets"),a().t("Pioneer insights"),a().t("Embark on adventures")|a().t("Moins de bruit, plus de clarté"),a().t("Vos données restent les vôtres"),a().t("Une question, une réponse fiable"),a().t("Pensez mieux, pas plus longtemps"),a().t("L'\''IA qui ne vous espionne pas"),a().t("Reprenez le contrôle de vos idées"),a().t("L'\''intelligence sans la surveillance"),a().t("Ce que l'\''IA devrait toujours être"),a().t("Votre prochaine bonne idée est ici"),a().t("Proxima Chat, partout avec vous")|' "$AUTH_JS"

    # 2c. Replace "Get started" button text
    sed -i 's|a().t("Get started")|a().t("Démarrer")|g' "$AUTH_JS"
    sed -i 's|a().t(`Get started`)|a().t(`Démarrer`)|g' "$AUTH_JS"

    # 2d. Replace top-left logo: swap the small icon img for our full logo
    # In compiled JS it's: `${M}/static/favicon.png` (template literal)
    sed -i 's|/static/favicon.png|/static/logo-auth-white.svg|g' "$AUTH_JS"

    echo "[Proxima] Auth page patched successfully"
else
    echo "[Proxima] WARNING: Could not find auth page JS to patch"
fi

# --- 3. Also patch the subtitle "wherever you are" ---
if [ -n "$AUTH_JS" ]; then
    sed -i 's|a().t("wherever you are")|a().t("où que vous soyez")|g' "$AUTH_JS"
fi

echo "[Proxima] All patches applied. Starting server..."

# --- Start Open WebUI ---
exec bash /app/backend/start.sh
