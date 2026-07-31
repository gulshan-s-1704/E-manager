# Deploying to Render

Render does not natively run Java/Tomcat WAR apps, and it does not offer a
managed MySQL database (only PostgreSQL). So this deployment has two parts:

1. **Get a MySQL database from an external provider** (Render will connect to it over the internet).
2. **Deploy this app to Render as a Docker Web Service** (a `Dockerfile` is already included).

---

## Part 1 — Get a MySQL Database

Pick one (all have free tiers as of writing — verify current pricing before committing):

| Provider | Notes |
|---|---|
| [Aiven](https://aiven.io/mysql) | Free trial MySQL, easy setup |
| [Railway](https://railway.app) | MySQL plugin, usage-based free credits |
| [Clever Cloud](https://www.clever-cloud.com/) | Free MySQL "Dev" tier |
| [PlanetScale](https://planetscale.com) | MySQL-compatible (Vitess) — check current free-tier availability |

After creating the database, note down:
- **Host** (e.g. `mysql-xxxxx.aivencloud.com`)
- **Port** (often not 3306 on managed providers — check!)
- **Database name**
- **Username**
- **Password**

### Load the schema
From your own machine, run:
```bash
mysql -h <HOST> -P <PORT> -u <USER> -p <DATABASE_NAME> < sql/schema.sql
```
(Some providers require `--ssl-mode=REQUIRED`; check your provider's docs.)

> Note: `sql/schema.sql` starts with `DROP DATABASE`/`CREATE DATABASE ecommerce_db;`.
> If your provider already assigns you a fixed database name, edit `sql/schema.sql`
> first — remove the `DROP DATABASE` / `CREATE DATABASE` / `USE` lines and instead
> run the `CREATE TABLE` statements directly against the database they gave you.

---

## Part 2 — Deploy to Render

### 1. Push this project to GitHub
Render deploys from a Git repo (GitHub/GitLab).
```bash
cd ecommerce-platform
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<your-username>/ecommerce-platform.git
git push -u origin main
```

### 2. Create a new Web Service on Render
1. Go to **https://dashboard.render.com** → **New** → **Web Service**
2. Connect your GitHub repo
3. Render will detect the `Dockerfile` automatically — choose **"Docker"** as the environment (should be auto-selected)
4. Set:
   - **Name**: `ecommerce-platform` (or anything)
   - **Region**: closest to you
   - **Branch**: `main`
   - **Instance Type**: Free (for testing) or a paid plan

### 3. Set Environment Variables

In the Render dashboard, under your Web Service → **Environment**, add these:

| Key | Value | Example |
|---|---|---|
| `DB_URL` | Full JDBC URL to your MySQL host | `jdbc:mysql://mysql-xxxxx.aivencloud.com:12345/ecommerce_db?useSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true` |
| `DB_USER` | MySQL username | `avnadmin` |
| `DB_PASSWORD` | MySQL password | `••••••••` |

That's it — only **3 environment variables** are required. The app code
(`DBConnection.java`) reads these at startup; if they're missing it falls
back to `localhost` defaults, which won't work on Render, so **don't skip this step**.

> `PORT` does **not** need to be set manually — Render injects it automatically,
> and the included `entrypoint.sh` script reconfigures Tomcat to listen on
> whatever port Render assigns.

### 4. Deploy
Click **"Create Web Service"**. Render will:
1. Build the Docker image (runs `mvn clean package` inside the container)
2. Start the container, which starts Tomcat with your WAR deployed as `ROOT.war`
3. Give you a public URL like `https://ecommerce-platform.onrender.com`

First build can take a few minutes (Maven downloading dependencies + Tomcat startup).

### 5. Verify
Visit `https://<your-app>.onrender.com/` — you should see the ShopEase homepage.
If it fails, check **Logs** in the Render dashboard — most failures at this stage
are either:
- Wrong `DB_URL`/`DB_USER`/`DB_PASSWORD` (connection refused / access denied)
- Your MySQL provider blocking Render's IP (check firewall/allowlist settings —
  most managed MySQL providers require you to allow "all IPs" or add Render's
  egress IPs, since Render's IPs aren't static on most plans)

---

## Local Docker Testing (optional, before pushing to Render)

You can test the exact same Docker image locally:
```bash
docker build -t ecommerce-platform .
docker run -p 8080:8080 \
  -e DB_URL="jdbc:mysql://host.docker.internal:3306/ecommerce_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e DB_USER="root" \
  -e DB_PASSWORD="root" \
  ecommerce-platform
```
Then open `http://localhost:8080/`.
(`host.docker.internal` lets the container reach MySQL running on your host machine.)

---

## Summary Checklist

- [ ] MySQL database created with an external provider
- [ ] `sql/schema.sql` loaded into that database
- [ ] Code pushed to a GitHub repo
- [ ] Render Web Service created, pointing at that repo, Docker environment
- [ ] `DB_URL`, `DB_USER`, `DB_PASSWORD` set in Render's Environment Variables
- [ ] Deployed and homepage loads at the Render URL
