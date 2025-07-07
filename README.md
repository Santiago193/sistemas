# 🛡️ Linux Jailed User Setup Script

This Bash script automatically creates **jailed Linux users** with FTP, Nginx web hosting, and a personal MySQL database — all in seconds.

---

## 🚀 What does this script do?

It automates the creation of an isolated and web-ready environment for new users:

- 🧑‍💻 Creates new users (`userX`) with restricted shell access.
- 🌐 Sets up their own `/home/userX/public_html` folder for hosting.
- 🔐 Assigns the username as the default password.
- 🗂️ Applies correct permissions for FTP (FileZilla) and web access.
- 🧰 Enforces user isolation using chroot with `vsftpd`.
- 🛠️ Creates a MySQL user and database with full access.
- 🌍 Automatically configures an Nginx block for the user's site.
- 🧾 Stores credentials in a secure TXT file under `/root`.

---

## 📦 Requirements

- A Linux server (tested on Ubuntu)
- `sudo` privileges
- Services installed:
  - `vsftpd`
  - `nginx`
  - `mysql-server`

---

## ⚙️ Installation

Clone this repo or copy the `crear_usuario_enjaulado.sh` script to your server:

```bash
git clone https://github.com/Santiago193/linux-user-setup.git
cd linux-user-setup
chmod +x crear_usuario_enjaulado.sh
```

---

## 🧪 Usage

Run the script with `sudo`:

```bash
sudo ./crear_usuario_enjaulado.sh usuario nuevo
```

> 🧠 It will automatically generate the next user like `user3`, `user4`, etc.

---

## 📁 Example

```bash
sudo ./crear_usuario_enjaulado.sh usuario nuevo
```

- Creates: `user3`
- Password: `user3`
- Web: `http://user3.com`
- FTP path: `/home/user3/public_html`

---

## 📄 Sample Output

```bash
======================================
 USER SUCCESSFULLY CREATED
======================================
Linux/FTP: user3
MySQL: user3
Password: user3
Website at: /home/user3/public_html
Credentials saved at: /root/credenciales_user3.txt
======================================
```

---

## 📌 Technical Features

- 👨‍🔧 Automatic incremental naming: `user1`, `user2`, ...
- 🔐 Chroot isolation for FTP users (`vsftpd`)
- 🌐 Dynamic Nginx virtual host creation
- 🧠 Hosts file updated for local domain access
- 💾 Secure permissions on web files and folders
- 🧾 TXT credential storage for every user

---

## 🔒 Security Notes

- Each user is jailed inside their home directory
- Files are assigned correct access permissions
- Credentials are stored safely in root-only files

---

## 📂 Generated Files

- `/home/userX/public_html/index.html`
- `/etc/nginx/sites-available/userX`
- `/etc/nginx/sites-enabled/userX`
- `/root/credenciales_userX.txt`

---

## 👤 Author

**Santiago David Castillo**  
Computer Science Engineering Student  
🔗 [GitHub](https://github.com/Santiago193)

---

## 📜 License

MIT © Santiago David Castillo
