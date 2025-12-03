#!/bin/bash

sudo pacman -S --needed --noconfirm obsidian
git clone git@github.com:caduhigueras/obsidian.git /home/arch/.local/share/obsidian

sudo touch /usr/local/bin/obsidian_sync
sudo chmod +x /usr/local/bin/obsidian_sync

sudo tee /usr/local/bin/obsidian_sync > /dev/null <<'EOF'
#!/bin/bash

cd /home/arch/.local/share/obsidian/
git fetch --all
git add .
git commit -m "Changes from home"
git push
EOF

sudo tee /etc/cron.d/sync_obsidian > /dev/null <<'EOF'
0 * * * * /usr/local/bin/obsidian_sync
EOF

