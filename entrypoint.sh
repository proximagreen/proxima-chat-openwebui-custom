#!/bin/bash
# Proxima Chat — Patch branding at startup

echo "[Proxima] Applying branding patches..."

# --- 1. Inject video background into index.html ---
INDEX="/app/build/index.html"
if [ -f "$INDEX" ] && ! grep -q "proxima-video-bg" "$INDEX"; then
    echo "[Proxima] Injecting video background into index.html"
    sed -i 's|<body|<body>\
<div id="proxima-video-bg"><video autoplay muted loop playsinline><source src="/static/proxima-bg.mp4" type="video/mp4"></video></div>\
<body-replaced|' "$INDEX"
    # Clean up the tag
    sed -i 's|<body-replaced||' "$INDEX"
fi

# --- 2. Patch onboarding marquee text ---
AUTH_JS=$(find /app/build/_app/immutable/nodes/ -name "*.js" -exec grep -l "Explore the cosmos" {} \; 2>/dev/null | head -1)

if [ -n "$AUTH_JS" ]; then
    echo "[Proxima] Patching marquee text in $AUTH_JS"
    sed -i \
        -e 's|a().t("Explore the cosmos")|a().t("Moins de bruit, plus de clarté")|g' \
        -e 's|a().t("Unlock mysteries")|a().t("Vos données restent les vôtres")|g' \
        -e 's|a().t("Chart new frontiers")|a().t("Une question, une réponse fiable")|g' \
        -e 's|a().t("Dive into knowledge")|a().t("Pensez mieux, pas plus longtemps")|g' \
        -e "s|a().t(\"Discover wonders\")|a().t(\"L'IA qui ne vous espionne pas\")|g" \
        -e "s|a().t(\"Ignite curiosity\")|a().t(\"Reprenez le contrôle de vos idées\")|g" \
        -e "s|a().t(\"Forge new paths\")|a().t(\"L'intelligence sans la surveillance\")|g" \
        -e "s|a().t(\"Unravel secrets\")|a().t(\"Ce que l'IA devrait toujours être\")|g" \
        -e 's|a().t("Pioneer insights")|a().t("Votre prochaine bonne idée est ici")|g' \
        -e 's|a().t("Embark on adventures")|a().t("Proxima Chat, partout avec vous")|g' \
        "$AUTH_JS"
fi

# --- 3. Patch "Get started" button text ---
if [ -n "$AUTH_JS" ]; then
    sed -i 's|a().t("Get started")|a().t("Démarrer")|g' "$AUTH_JS"
fi

echo "[Proxima] Branding patches applied."

# --- Start Open WebUI ---
exec bash /app/backend/start.sh
