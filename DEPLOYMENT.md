# 🚀 GitHub Pages Deployment Guide

Your TI-89 Tunnel emulator is ready to deploy to the web!

## Quick Deploy Steps

### Step 1: Enable GitHub Pages

1. Go to your repository on GitHub:
   ```
   https://github.com/jcliff/tunnel89
   ```

2. Click **Settings** (in the top navigation)

3. Scroll down and click **Pages** (in the left sidebar)

4. Under **Source**, select:
   - Source: **GitHub Actions**

   (You should see the "Deploy TI-89 Emulator to GitHub Pages" workflow listed)

5. Click **Save**

### Step 2: Wait for Deployment

The GitHub Actions workflow will automatically:
- Build your site
- Deploy to GitHub Pages
- Usually takes 1-2 minutes

You can watch the progress at:
```
https://github.com/jcliff/tunnel89/actions
```

### Step 3: Access Your Site!

Once deployed, your emulator will be live at:

```
🌐 https://jcliff.github.io/tunnel89/
```

**Bookmark this!** You can now access your TI-89 emulator from:
- Your phone 📱
- Your laptop 💻
- Any device with a browser 🌍

## Manual Deployment Trigger

If you need to redeploy manually:

1. Go to: https://github.com/jcliff/tunnel89/actions
2. Click on "Deploy TI-89 Emulator to GitHub Pages"
3. Click "Run workflow" button
4. Select the branch and click "Run workflow"

## What Gets Deployed

Everything in the repository:
- ✓ `index.html` - Main launcher page
- ✓ `emulator/` - Full TI-89 emulator
- ✓ `tunnel.89z` - Your game file (downloadable)
- ✓ All documentation files

## Automatic Deployments

The workflow is configured to auto-deploy on push to:
- `claude/ti89-emulator-yPa1z`
- `master`
- `main`

Every time you push changes, the site updates automatically!

## Troubleshooting

### "Actions" tab is disabled?
- Go to Settings → Actions → General
- Enable "Allow all actions and reusable workflows"
- Save

### Deployment failed?
- Check the Actions tab for error logs
- Make sure GitHub Pages is enabled in Settings
- Verify the workflow file exists: `.github/workflows/deploy-pages.yml`

### Site not updating?
- Check if deployment succeeded in Actions tab
- Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
- Wait 1-2 minutes after deployment completes

### 404 Error?
- Make sure you're using the correct URL: `https://jcliff.github.io/tunnel89/`
- Verify Pages is enabled and source is set to "GitHub Actions"
- Check if index.html exists in the repository root

## Custom Domain (Optional)

Want to use a custom domain like `tunnel89.yourdomain.com`?

1. In Pages settings, add your custom domain
2. Configure DNS with your domain provider:
   - Add CNAME record pointing to `jcliff.github.io`
3. GitHub will automatically handle HTTPS

## Mobile Access

Once deployed, you can:
- **Save to Home Screen** on iOS/Android (looks like a native app!)
- **Share the link** with friends
- **Access from anywhere** with internet

## Local vs Web

| Feature | Local (`./start_emulator.sh`) | Web (GitHub Pages) |
|---------|-------------------------------|-------------------|
| Access | Only from your computer | Anywhere in the world |
| Mobile | Requires network setup | Direct access via URL |
| Speed | Fastest (local) | Fast (CDN-cached) |
| Sharing | Difficult | Just share the URL |
| Updates | Instant | Push to git (~2 min delay) |

## Sharing Your Emulator

Once live, share this URL:
```
https://jcliff.github.io/tunnel89/
```

Your friends can:
- Play with the TI-89 emulator
- Download tunnel.89z
- See your awesome retro game!

## What's Next?

After enabling GitHub Pages, you can:
1. ✓ Access from your phone at the URL above
2. ✓ Share with friends
3. ✓ Make changes locally and push to auto-update
4. ✓ Add more TI-89 programs to the collection

---

**Ready to go live?** Head to your repo settings and enable GitHub Pages now! 🚀

Repository: https://github.com/jcliff/tunnel89
Live Site: https://jcliff.github.io/tunnel89/ (once enabled)
