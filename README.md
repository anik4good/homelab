# 🏠 Homelab Infrastructure

This repository contains the configuration and automation setup for my personal homelab environment. The goal is to maintain a modular, reproducible, and automated system using modern DevOps practices.

---

## 📁 Folder Structure

```markdown

homelab/
├── ansible/      # Infrastructure automation (playbooks, inventory)
├── docker/       # Docker Compose setups for all self-hosted apps
├── jenkins/      # CI/CD pipelines and automation jobs
├── scripts/      # Custom scripts for backups and utilities
├── terraform/    # Proxmox VM/LXC provisioning via Terraform
└── README.md     # This file
```


## ⚙️ Stack Overview

- **Proxmox VE**: Virtualization platform for managing LXCs and VMs
- **Ansible**: Infrastructure-as-Code for configuration management
- **Docker & Docker Compose**: Application containerization
- **Terraform**: Automated provisioning of VMs and LXCs on Proxmox
- **Jenkins**: CI/CD pipelines for automated deployment and backups

---

## 🚀 Current Self-Hosted Applications

Apps are deployed via Docker Compose and managed through the `docker/` directory. A few examples include:

- 📚 `audiobookshelf`
- 🎥 `emby`
- 🌐 `nginx` & `nginx-proxy-manager`
- 🧭 `homarr`, `homepage`
- ☁️ `nextcloud`
- 📈 `uptime-kuma`
- 🔐 `cloudflared`, `openwebui`

Each app directory includes its own `docker-compose.yml` and `.env` file (secrets are managed via Ansible Vault).

---

## 🔐 Security & Secrets

- `.env` files and sensitive configurations are **excluded from Git** via `.gitignore`
- Secrets are managed securely using **Ansible Vault**
- Git only tracks public-facing configuration

---

## 🔄 Deployment Flow

1. **Clone Repo** to Proxmox or Docker host
2. **Ansible Playbooks** sync configurations and set up Docker environment
3. **Terraform** provisions VMs/LXCs on Proxmox
4. **Jenkins** executes pipelines for automation, deployment, or backups
5. **Docker Compose** brings services up based on the versioned files in `docker/`

---

## 📦 Git Best Practices

- Use `.gitignore` to keep sensitive data out of Git
- Each app has isolated config for clarity and modularity
- Git commits include only structure and safe config

---

## 📌 Notes

- This setup is optimized for **home lab use**, not production
- Most services run on a **dedicated Proxmox server** with Docker inside LXCs
- Some components run on other machines (e.g. backup/secondary systems)

---

## 📜 License

This repo is for **personal use** and may not be suitable for commercial production without adaptation.

---

