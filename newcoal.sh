#!/bin/bash

# ─────────────────────────────────────────────────────────
#  CoalCoin Project - File Generator
#  ذغال‌سنگ کوین - اسکریپت ساخت فایل‌های پروژه
# ─────────────────────────────────────────────────────────

set -e  # exit on error

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ── Banner ──
echo -e "${CYAN}${BOLD}"
echo "  ██████╗ ██████╗  █████╗ ██╗      ██████╗ ██████╗ ██╗███╗   ██╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██║     ██╔════╝██╔═══██╗██║████╗  ██║"
echo " ██║     ██║   ██║███████║██║     ██║     ██║   ██║██║██╔██╗ ██║"
echo " ██║     ██║   ██║██╔══██║██║     ██║     ██║   ██║██║██║╚██╗██║"
echo " ╚██████╗╚██████╔╝██║  ██║███████╗╚██████╗╚██████╔╝██║██║ ╚████║"
echo "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝"
echo -e "${NC}"
echo -e "${YELLOW}  ذغال‌سنگ کوین - Project File Generator${NC}"
echo -e "${YELLOW}  ─────────────────────────────────────${NC}\n"

# ─────────────────────────────────────────────────────────
#  Step 1: Create Directory Structure
# ─────────────────────────────────────────────────────────

echo -e "${CYAN}[1/6]${NC} Creating directory structure..."

mkdir -p coalcoin/{frontend,contracts,scripts,assets/gif}

cd coalcoin

echo -e "      ${GREEN}✓${NC} frontend/"
echo -e "      ${GREEN}✓${NC} contracts/"
echo -e "      ${GREEN}✓${NC} scripts/"
echo -e "      ${GREEN}✓${NC} assets/gif/"

# ─────────────────────────────────────────────────────────
#  Step 2: index.html
# ─────────────────────────────────────────────────────────

echo -e "\n${CYAN}[2/6]${NC} Creating frontend/index.html..."

cat > frontend/index.html << 'HTML_EOF'
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ذغال‌سنگ کوین ⛏️</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>

  <!-- Digital Rain GIF Background -->
  <div class="rain-overlay">
    <img src="../assets/gif/digital-rain.gif" alt="digital rain" />
  </div>

  <!-- Main Container -->
  <div class="container">

    <!-- Header -->
    <header class="mc-header">
      <div class="mc-logo">⛏️</div>
      <h1 class="mc-title">ذغال‌سنگ کوین</h1>
      <p class="mc-subtitle">COAL COIN · ERC-20</p>
    </header>

    <!-- Wallet Section -->
    <div class="mc-panel" id="wallet-panel">
      <button class="mc-btn btn-connect" id="btn-connect">
        🦊 اتصال MetaMask
      </button>
      <div class="wallet-info hidden" id="wallet-info">
        <span class="label">آدرس:</span>
        <span class="value mono" id="wallet-address">—</span>
      </div>
    </div>

    <!-- Balance Section -->
    <div class="mc-panel" id="balance-panel">
      <h2 class="panel-title">💰 موجودی</h2>
      <div class="balance-display">
        <span id="token-balance">0</span>
        <span class="token-symbol">COAL</span>
      </div>
      <div class="balance-eth">
        <span class="label">ETH:</span>
        <span id="eth-balance">0</span>
      </div>
      <button class="mc-btn btn-refresh" id="btn-refresh">🔄 بروزرسانی</button>
    </div>

    <!-- Mint Section -->
    <div class="mc-panel" id="mint-panel">
      <h2 class="panel-title">⛏️ مینت توکن</h2>

      <!-- Whitelist Mint -->
      <div class="mint-box">
        <h3>🔑 مینت لیست سفید</h3>
        <input
          class="mc-input"
          type="number"
          id="wl-amount"
          placeholder="تعداد توکن"
          min="1"
        />
        <input
          class="mc-input"
          type="text"
          id="wl-proof"
          placeholder="Merkle Proof (آرایه JSON)"
        />
        <button class="mc-btn btn-mint" id="btn-wl-mint">
          مینت با Whitelist
        </button>
      </div>

      <!-- Public Mint -->
      <div class="mint-box">
        <h3>🌐 مینت عمومی</h3>
        <input
          class="mc-input"
          type="number"
          id="pub-amount"
          placeholder="تعداد توکن"
          min="1"
        />
        <button class="mc-btn btn-mint" id="btn-pub-mint">
          مینت عمومی
        </button>
      </div>
    </div>

    <!-- Burn Section -->
    <div class="mc-panel" id="burn-panel">
      <h2 class="panel-title">🔥 سوزاندن توکن</h2>
      <input
        class="mc-input"
        type="number"
        id="burn-amount"
        placeholder="مقدار برای سوزاندن"
        min="1"
      />
      <button class="mc-btn btn-burn" id="btn-burn">
        🔥 بسوزان
      </button>
    </div>

    <!-- Transfer Section -->
    <div class="mc-panel" id="transfer-panel">
      <h2 class="panel-title">📤 انتقال توکن</h2>
      <input
        class="mc-input"
        type="text"
        id="transfer-to"
        placeholder="آدرس گیرنده (0x...)"
      />
      <input
        class="mc-input"
        type="number"
        id="transfer-amount"
        placeholder="مقدار"
        min="1"
      />
      <button class="mc-btn btn-transfer" id="btn-transfer">
        📤 ارسال
      </button>
    </div>

    <!-- Contract Info -->
    <div class="mc-panel" id="info-panel">
      <h2 class="panel-title">📋 اطلاعات قرارداد</h2>
      <div class="info-grid">
        <div class="info-row">
          <span class="label">عرضه کل:</span>
          <span id="total-supply">—</span>
        </div>
        <div class="info-row">
          <span class="label">حداکثر عرضه:</span>
          <span id="max-supply">—</span>
        </div>
        <div class="info-row">
          <span class="label">قیمت Mint:</span>
          <span id="mint-price">—</span>
        </div>
        <div class="info-row">
          <span class="label">فروش عمومی:</span>
          <span id="public-sale-status">—</span>
        </div>
      </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast hidden" id="toast"></div>

  </div><!-- end .container -->

  <script src="https://cdn.ethers.io/lib/ethers-5.7.2.umd.min.js"></script>
  <script src="app.js"></script>
</body>
</html>
HTML_EOF

echo -e "      ${GREEN}✓${NC} index.html created"

# ─────────────────────────────────────────────────────────
#  Step 3: style.css
# ─────────────────────────────────────────────────────────

echo -e "\n${CYAN}[3/6]${NC} Creating frontend/style.css..."

cat > frontend/style.css << 'CSS_EOF'
/* ─────────────────────────────────────────────
   CoalCoin - Minecraft Style CSS
   ───────────────────────────────────────────── */

@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');

/* ── Reset ── */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* ── Root Variables ── */
:root {
  --mc-dark:    #1a1a1a;
  --mc-darker:  #0d0d0d;
  --mc-panel:   #2d2d2d;
  --mc-border:  #555555;
  --mc-gold:    #ffaa00;
  --mc-green:   #44ff44;
  --mc-red:     #ff4444;
  --mc-blue:    #4444ff;
  --mc-cyan:    #00ffff;
  --mc-text:    #ffffff;
  --mc-dim:     #aaaaaa;
  --pixel:      2px;
}

/* ── Body ── */
body {
  background-color: var(--mc-darker);
  color: var(--mc-text);
  font-family: 'Press Start 2P', monospace;
  font-size: 12px;
  line-height: 1.8;
  min-height: 100vh;
  overflow-x: hidden;
}

/* ── Digital Rain Background ── */
.rain-overlay {
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  z-index: 0;
  opacity: 0.07;
  pointer-events: none;
  overflow: hidden;
}

.rain-overlay img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* ── Container ── */
.container {
  position: relative;
  z-index: 1;
  max-width: 700px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* ── Header ── */
.mc-header {
  text-align: center;
  padding: 24px 16px;
  background: var(--mc-panel);
  border: var(--pixel) solid var(--mc-gold);
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #ffffff22,
    0 0 20px #ffaa0033;
  image-rendering: pixelated;
}

.mc-logo {
  font-size: 48px;
  display: block;
  margin-bottom: 12px;
  filter: drop-shadow(0 0 8px var(--mc-gold));
}

.mc-title {
  font-size: 20px;
  color: var(--mc-gold);
  text-shadow:
    var(--pixel) var(--pixel) 0 #000,
    0 0 10px var(--mc-gold);
  letter-spacing: 2px;
}

.mc-subtitle {
  font-size: 8px;
  color: var(--mc-dim);
  margin-top: 8px;
  letter-spacing: 4px;
}

/* ── Panels ── */
.mc-panel {
  background: var(--mc-panel);
  border: var(--pixel) solid var(--mc-border);
  padding: 16px;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #ffffff11,
    inset calc(-1 * var(--pixel)) calc(-1 * var(--pixel)) 0 #00000044;
  image-rendering: pixelated;
}

.panel-title {
  font-size: 11px;
  color: var(--mc-gold);
  margin-bottom: 14px;
  padding-bottom: 8px;
  border-bottom: var(--pixel) solid var(--mc-border);
}

/* ── Buttons ── */
.mc-btn {
  display: inline-block;
  width: 100%;
  padding: 10px 16px;
  font-family: 'Press Start 2P', monospace;
  font-size: 10px;
  cursor: pointer;
  border: none;
  image-rendering: pixelated;
  transition: filter 0.1s, transform 0.1s;
  text-align: center;
  margin-top: 8px;
}

.mc-btn:active {
  transform: translateY(var(--pixel));
  filter: brightness(0.85);
}

.btn-connect {
  background: #5a7c3a;
  color: #fff;
  border: var(--pixel) solid #2d4a1a;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #7db35a,
    inset calc(-1 * var(--pixel)) calc(-1 * var(--pixel)) 0 #2d4a1a;
}

.btn-connect:hover { background: #6a9248; }

.btn-refresh {
  background: #3a5a8c;
  color: #fff;
  border: var(--pixel) solid #1a2d5a;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #5a82c8,
    inset calc(-1 * var(--pixel)) calc(-1 * var(--pixel)) 0 #1a2d5a;
}

.btn-mint {
  background: #7c5a3a;
  color: #fff;
  border: var(--pixel) solid #4a2d1a;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #b38a5a,
    inset calc(-1 * var(--pixel)) calc(-1 * var(--pixel)) 0 #4a2d1a;
}

.btn-mint:hover { background: #9a7248; }

.btn-burn {
  background: #8c2a2a;
  color: #fff;
  border: var(--pixel) solid #5a1a1a;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #c85a5a,
    inset calc(-1 * var(--pixel)) calc(-1 * var(--pixel)) 0 #5a1a1a;
}

.btn-burn:hover { background: #aa3333; }

.btn-transfer {
  background: #2a5a8c;
  color: #fff;
  border: var(--pixel) solid #1a3a5a;
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #5a8abc;
}

.btn-transfer:hover { background: #3366a8; }

/* ── Inputs ── */
.mc-input {
  display: block;
  width: 100%;
  padding: 9px 12px;
  margin-top: 8px;
  background: var(--mc-darker);
  border: var(--pixel) solid var(--mc-border);
  color: var(--mc-text);
  font-family: 'Press Start 2P', monospace;
  font-size: 9px;
  outline: none;
  box-shadow: inset var(--pixel) var(--pixel) 0 #00000066;
  direction: ltr;
}

.mc-input:focus {
  border-color: var(--mc-gold);
  box-shadow:
    inset var(--pixel) var(--pixel) 0 #00000066,
    0 0 6px var(--mc-gold);
}

.mc-input::placeholder { color: var(--mc-border); }

/* ── Balance Display ── */
.balance-display {
  text-align: center;
  padding: 16px;
  background: var(--mc-darker);
  border: var(--pixel) solid var(--mc-border);
  margin-bottom: 10px;
}

.balance-display span:first-child {
  font-size: 28px;
  color: var(--mc-gold);
  text-shadow: 0 0 10px var(--mc-gold);
}

.token-symbol {
  font-size: 12px;
  color: var(--mc-dim);
  margin-right: 8px;
}

.balance-eth {
  font-size: 9px;
  color: var(--mc-dim);
  margin-bottom: 8px;
}

/* ── Wallet Info ── */
.wallet-info {
  margin-top: 10px;
  font-size: 8px;
  word-break: break-all;
  direction: ltr;
}

.mono {
  font-family: monospace;
  color: var(--mc-cyan);
}

/* ── Info Grid ── */
.info-grid {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 8px;
  background: var(--mc-darker);
  border: var(--pixel) solid var(--mc-border);
  font-size: 9px;
}

.label { color: var(--mc-dim); }
.value { color: var(--mc-cyan); }

/* ── Mint Box ── */
.mint-box {
  background: var(--mc-darker);
  border: var(--pixel) solid var(--mc-border);
  padding: 12px;
  margin-bottom: 10px;
}

.mint-box h3 {
  font-size: 9px;
  color: var(--mc-cyan);
  margin-bottom: 8px;
}

/* ── Toast ── */
.toast {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--mc-panel);
  border: var(--pixel) solid var(--mc-gold);
  padding: 10px 20px;
  font-size: 9px;
  z-index: 999;
  text-align: center;
  max-width: 90%;
  box-shadow: 0 0 12px var(--mc-gold);
  animation: fadeInUp 0.3s ease;
}

.toast.error  { border-color: var(--mc-red);   box-shadow: 0 0 12px var(--mc-red); }
.toast.success{ border-color: var(--mc-green);  box-shadow: 0 0 12px var(--mc-green); }

@keyframes fadeInUp {
  from { opacity: 0; transform: translateX(-50%) translateY(10px); }
  to   { opacity: 1; transform: translateX(-50%) translateY(0); }
}

/* ── Hidden ── */
.hidden { display: none !important; }

/* ── Scrollbar ── */
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: var(--mc-darker); }
::-webkit-scrollbar-thumb { background: var(--mc-border); }

/* ── Responsive ── */
@media (max-width: 480px) {
  .mc-title    { font-size: 14px; }
  .mc-btn      { font-size: 8px; padding: 8px; }
  .mc-input    { font-size: 8px; }
}
CSS_EOF

echo -e "      ${GREEN}✓${NC} style.css created"

# ─────────────────────────────────────────────────────────
#  Step 4: app.js
# ─────────────────────────────────────────────────────────

echo -e "\n${CYAN}[4/6]${NC} Creating frontend/app.js..."

cat > frontend/app.js << 'JS_EOF'
// ─────────────────────────────────────────────────────────
//  CoalCoin - app.js
//  ⚠️  CONTRACT_ADDRESS و ABI را پر کنید
// ─────────────────────────────────────────────────────────

// ══════════════════════════════════════════
//  CONFIG  ← اینجا را ویرایش کنید
// ══════════════════════════════════════════

const CONTRACT_ADDRESS = "0x_YOUR_CONTRACT_ADDRESS_HERE";

const ABI = [
  // ── Read ──
  "function balanceOf(address) view returns (uint256)",
  "function totalSupply() view returns (uint256)",
  "function maxSupply() view returns (uint256)",
  "function mintPrice() view returns (uint256)",
  "function publicSaleActive() view returns (bool)",
  "function whitelistClaimed(address) view returns (bool)",
  "function isWhitelisted(address, bytes32[]) view returns (bool)",

  // ── Write ──
  "function whitelistMint(uint256 amount, bytes32[] proof) payable",
  "function publicMint(uint256 amount) payable",
  "function burn(uint256 amount)",
  "function transfer(address to, uint256 amount) returns (bool)",

  // ── Events ──
  "event Transfer(address indexed from, address indexed to, uint256 value)",
  "event WhitelistMinted(address indexed user, uint256 amount)",
  "event PublicMinted(address indexed user, uint256 amount)",
];

// ══════════════════════════════════════════
//  State
// ══════════════════════════════════════════
let provider, signer, contract, userAddress;

// ══════════════════════════════════════════
//  DOM Elements
// ══════════════════════════════════════════
const $ = (id) => document.getElementById(id);

const btnConnect    = $("btn-connect");
const btnRefresh    = $("btn-refresh");
const btnWlMint     = $("btn-wl-mint");
const btnPubMint    = $("btn-pub-mint");
const btnBurn       = $("btn-burn");
const btnTransfer   = $("btn-transfer");
const walletInfo    = $("wallet-info");
const walletAddress = $("wallet-address");

// ══════════════════════════════════════════
//  Toast Notification
// ══════════════════════════════════════════
function showToast(msg, type = "info", duration = 3500) {
  const toast = $("toast");
  toast.textContent = msg;
  toast.className   = `toast ${type}`;
  toast.classList.remove("hidden");
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => toast.classList.add("hidden"), duration);
}

// ══════════════════════════════════════════
//  Connect Wallet
// ══════════════════════════════════════════
btnConnect.addEventListener("click", async () => {
  if (!window.ethereum) {
    showToast("MetaMask پیدا نشد! لطفاً نصب کنید.", "error");
    return;
  }

  try {
    btnConnect.textContent = "در حال اتصال...";

    provider    = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer      = provider.getSigner();
    userAddress = await signer.getAddress();
    contract    = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    walletAddress.textContent = shortAddr(userAddress);
    walletInfo.classList.remove("hidden");
    btnConnect.textContent = "✅ متصل";

    await refreshAll();
    showToast("کیف‌پول متصل شد ✅", "success");

    // listen for account changes
    window.ethereum.on("accountsChanged", () => location.reload());
    window.ethereum.on("chainChanged",    () => location.reload());

  } catch (err) {
    console.error(err);
    btnConnect.textContent = "🦊 اتصال MetaMask";
    showToast("خطا در اتصال: " + (err.message || err), "error");
  }
});

// ══════════════════════════════════════════
//  Refresh All Data
// ══════════════════════════════════════════
btnRefresh.addEventListener("click", refreshAll);

async function refreshAll() {
  if (!contract || !userAddress) return;

  try {
    const [bal, total, max, price, pubActive, ethBal] = await Promise.all([
      contract.balanceOf(userAddress),
      contract.totalSupply(),
      contract.maxSupply(),
      contract.mintPrice(),
      contract.publicSaleActive(),
      provider.getBalance(userAddress),
    ]);

    $("token-balance").textContent =
      parseFloat(ethers.utils.formatEther(bal)).toFixed(2);

    $("total-supply").textContent =
      parseFloat(ethers.utils.formatEther(total)).toLocaleString();

    $("max-supply").textContent =
      parseFloat(ethers.utils.formatEther(max)).toLocaleString();

    $("mint-price").textContent =
      ethers.utils.formatEther(price) + " ETH";

    $("eth-balance").textContent =
      parseFloat(ethers.utils.formatEther(ethBal)).toFixed(4);

    $("public-sale-status").textContent = pubActive ? "✅ فعال" : "❌ غیرفعال";

  } catch (err) {
    console.error("Refresh error:", err);
    showToast("خطا در بروزرسانی", "error");
  }
}

// ══════════════════════════════════════════
//  Whitelist Mint
// ══════════════════════════════════════════
btnWlMint.addEventListener("click", async () => {
  if (!contract) { showToast("ابتدا MetaMask را وصل کنید", "error"); return; }

  const amount    = parseInt($("wl-amount").value);
  const proofRaw  = $("wl-proof").value.trim();

  if (!amount || amount < 1) {
    showToast("مقدار معتبر وارد کنید", "error"); return;
  }

  let proof;
  try {
    proof = JSON.parse(proofRaw);
    if (!Array.isArray(proof)) throw new Error();
  } catch {
    showToast("Proof باید آرایه JSON باشد مثال: [\"0x...\",\"0x...\"]", "error");
    return;
  }

  try {
    btnWlMint.textContent = "در حال ارسال...";

    const price = await contract.mintPrice();
    const cost  = price.mul(amount);

    const tx = await contract.whitelistMint(amount, proof, { value: cost });
    showToast("تراکنش ارسال شد، منتظر تأیید...", "info");
    await tx.wait();

    showToast(`${amount} توکن با موفقیت مینت شد ⛏️`, "success");
    await refreshAll();

  } catch (err) {
    console.error(err);
    showToast("خطا: " + parseError(err), "error");
  } finally {
    btnWlMint.textContent = "مینت با Whitelist";
  }
});

// ══════════════════════════════════════════
//  Public Mint
// ══════════════════════════════════════════
btnPubMint.addEventListener("click", async () => {
  if (!contract) { showToast("ابتدا MetaMask را وصل کنید", "error"); return; }

  const amount = parseInt($("pub-amount").value);
  if (!amount || amount < 1) {
    showToast("مقدار معتبر وارد کنید", "error"); return;
  }

  try {
    btnPubMint.textContent = "در حال ارسال...";

    const price = await contract.mintPrice();
    const cost  = price.mul(amount);

    const tx = await contract.publicMint(amount, { value: cost });
    showToast("تراکنش ارسال شد، منتظر تأیید...", "info");
    await tx.wait();

    showToast(`${amount} توکن مینت شد 🌐`, "success");
    await refreshAll();

  } catch (err) {
    console.error(err);
    showToast("خطا: " + parseError(err), "error");
  } finally {
    btnPubMint.textContent = "مینت عمومی";
  }
});

// ══════════════════════════════════════════
//  Burn
// ══════════════════════════════════════════
btnBurn.addEventListener("click", async () => {
  if (!contract) { showToast("ابتدا MetaMask را وصل کنید", "error"); return; }

  const amount = parseFloat($("burn-amount").value);
  if (!amount || amount <= 0) {
    showToast("مقدار معتبر وارد کنید", "error"); return;
  }

  if (!confirm(`آیا مطمئنید که ${amount} COAL را می‌سوزانید؟ این عمل برگشت‌ناپذیر است!`)) return;

  try {
    btnBurn.textContent = "در حال سوزاندن...";

    const amountWei = ethers.utils.parseEther(amount.toString());
    const tx        = await contract.burn(amountWei);
    showToast("تراکنش ارسال شد...", "info");
    await tx.wait();

    showToast(`${amount} COAL سوزانده شد 🔥`, "success");
    await refreshAll();

  } catch (err) {
    console.error(err);
    showToast("خطا: " + parseError(err), "error");
  } finally {
    btnBurn.textContent = "🔥 بسوزان";
  }
});

// ══════════════════════════════════════════
//  Transfer
// ══════════════════════════════════════════
btnTransfer.addEventListener("click", async () => {
  if (!contract) { showToast("ابتدا MetaMask را وصل کنید", "error"); return; }

  const to     = $("transfer-to").value.trim();
  const amount = parseFloat($("transfer-amount").value);

  if (!ethers.utils.isAddress(to)) {
    showToast("آدرس معتبر نیست", "error"); return;
  }
  if (!amount || amount <= 0) {
    showToast("مقدار معتبر وارد کنید", "error"); return;
  }

  try {
    btnTransfer.textContent = "در حال ارسال...";

    const amountWei = ethers.utils.parseEther(amount.toString());
    const tx        = await contract.transfer(to, amountWei);
    showToast("تراکنش ارسال شد...", "info");
    await tx.wait();

    showToast(`${amount} COAL به ${shortAddr(to)} ارسال شد 📤`, "success");
    await refreshAll();

  } catch (err) {
    console.error(err);
    showToast("خطا: " + parseError(err), "error");
  } finally {
    btnTransfer.textContent = "📤 ارسال";
  }
});

// ══════════════════════════════════════════
//  Helpers
// ══════════════════════════════════════════
function shortAddr(addr) {
  return addr.slice(0, 6) + "..." + addr.slice(-4);
}

function parseError(err) {
  if (err.reason)  return err.reason;
  if (err.message) return err.message.slice(0, 80);
  return "خطای ناشناخته";
}
JS_EOF

echo -e "      ${GREEN}✓${NC} app.js created"

# ─────────────────────────────────────────────────────────
#  Step 5: Solidity Contract
# ─────────────────────────────────────────────────────────

echo -e "\n${CYAN}[5/6]${NC} Creating contracts/CoalCoin.sol..."

cat > contracts/CoalCoin.sol << 'SOL_EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract CoalCoin is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {

    uint256 public immutable maxSupply;
    bytes32 public merkleRoot;
    uint256 public mintPrice;
    bool    public publicSaleActive;
    uint256 public whitelistMaxMint;

    mapping(address => bool) public whitelistClaimed;

    event MerkleRootUpdated(bytes32 indexed oldRoot, bytes32 indexed newRoot);
    event WhitelistMinted(address indexed user, uint256 amount);
    event PublicMinted(address indexed user, uint256 amount);
    event PublicSaleToggled(bool active);
    event Withdrawn(address indexed to, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        bytes32 merkleRoot_,
        uint256 mintPrice_,
        uint256 whitelistMaxMint_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        require(maxSupply_ > 0, "CoalCoin: maxSupply must be > 0");
        maxSupply        = maxSupply_;
        merkleRoot       = merkleRoot_;
        mintPrice        = mintPrice_;
        whitelistMaxMint = whitelistMaxMint_;
    }

    function whitelistMint(
        uint256 amount,
        bytes32[] calldata proof
    ) external payable nonReentrant {
        require(!whitelistClaimed[msg.sender],          "CoalCoin: already claimed");
        require(amount > 0 && amount <= whitelistMaxMint, "CoalCoin: invalid amount");
        require(totalSupply() + amount * 1e18 <= maxSupply, "CoalCoin: exceeds maxSupply");
        require(msg.value >= mintPrice * amount,         "CoalCoin: insufficient ETH");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "CoalCoin: invalid proof");

        whitelistClaimed[msg.sender] = true;
        _mint(msg.sender, amount * 1e18);
        emit WhitelistMinted(msg.sender, amount);

        uint256 excess = msg.value - mintPrice * amount;
        if (excess > 0) {
            (bool ok, ) = payable(msg.sender).call{value: excess}("");
            require(ok, "CoalCoin: refund failed");
        }
    }

    function publicMint(uint256 amount) external payable nonReentrant {
        require(publicSaleActive, "CoalCoin: public sale not active");
        require(amount > 0, "CoalCoin: amount must be > 0");
        require(totalSupply() + amount * 1e18 <= maxSupply, "CoalCoin: exceeds maxSupply");
        require(msg.value >= mintPrice * amount, "CoalCoin: insufficient ETH");

        _mint(msg.sender, amount * 1e18);
        emit PublicMinted(msg.sender, amount);

        uint256 excess = msg.value - mintPrice * amount;
        if (excess > 0) {
            (bool ok, ) = payable(msg.sender).call{value: excess}("");
            require(ok, "CoalCoin: refund failed");
        }
    }

    function ownerMint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "CoalCoin: exceeds maxSupply");
        _mint(to, amount);
    }

    function setMerkleRoot(bytes32 newRoot) external onlyOwner {
        emit MerkleRootUpdated(merkleRoot, newRoot);
        merkleRoot = newRoot;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function togglePublicSale() external onlyOwner {
        publicSaleActive = !publicSaleActive;
        emit PublicSaleToggled(publicSaleActive);
    }

    function withdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "CoalCoin: nothing to withdraw");
        (bool ok, ) = payable(owner()).call{value: balance}("");
        require(ok, "CoalCoin: withdraw failed");
        emit Withdrawn(owner(), balance);
    }

    function isWhitelisted(
        address account,
        bytes32[] calldata proof
    ) external view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(account));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
SOL_EOF

echo -e "      ${GREEN}✓${NC} CoalCoin.sol created"

# ─────────────────────────────────────────────────────────
#  Step 6: Merkle Generator Script
# ─────────────────────────────────────────────────────────

echo -e "\n${CYAN}[6/6]${NC} Creating scripts/merkle-generator.js..."

cat > scripts/merkle-generator.js << 'MERKLE_EOF'
// ─────────────────────────────────────────────────────────
//  CoalCoin - Merkle Tree Generator
//  نصب: npm install merkletreejs keccak256 ethers
// ─────────────────────────────────────────────────────────

const { MerkleTree } = require("merkletreejs");
const keccak256       = require("keccak256");
const { ethers }      = require("ethers");
const fs              = require("fs");

// ── ۱. لیست whitelist را اینجا وارد کنید ──
const whitelist = [
  "0x0000000000000000000000000000000000000001",
  "0x0000000000000000000000000000000000000002",
  // ... آدرس‌های بیشتر
];

function buildLeaf(addr) {
  return keccak256(
    Buffer.from(
      ethers.utils.solidityPack(["address"], [addr]).slice(2),
      "hex"
    )
  );
}

// ── ۲. ساخت درخت ──
const leaves = whitelist.map(buildLeaf);
const tree   = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root   = tree.getHexRoot();

console.log("\n══════════════════════════════════");
console.log("  Merkle Root:");
console.log(" ", root);
console.log("══════════════════════════════════\n");

// ── ۳. ساخت proof برای همه آدرس‌ها ──
const proofs = {};
whitelist.forEach((addr) => {
  const leaf  = buildLeaf(addr);
  const proof = tree.getHexProof(leaf);
  proofs[addr.toLowerCase()] = proof;
  console.log(`${addr} → ${proof.length} nodes`);
});

// ── ۴. ذخیره در فایل JSON ──
const output = { root, proofs };
fs.writeFileSync("proofs.json", JSON.stringify(output, null, 2));
console.log("\n✅  proofs.json ذخیره شد");
console.log("    merkleRoot برای constructor:", root);

// ── ۵. تابع verify ──
function verify(addr, proof) {
  const leaf    = buildLeaf(addr);
  const rootBuf = Buffer.from(root.slice(2), "hex");
  const proofBuf = proof.map((p) => Buffer.from(p.slice(2), "hex"));
  return tree.verify(proofBuf, leaf, rootBuf);
}

// تست
console.log("\n── تست verify ──");
const testAddr  = whitelist[0];
const testProof = proofs[testAddr.toLowerCase()];
console.log(`${testAddr}: ${verify(testAddr, testProof) ? "✅ valid" : "❌ invalid"}`);
MERKLE_EOF

echo -e "      ${GREEN}✓${NC} merkle-generator.js created"

# ─────────────────────────────────────────────────────────
#  package.json
# ─────────────────────────────────────────────────────────

cat > package.json << 'PKG_EOF'
{
  "name": "coalcoin",
  "version": "1.0.0",
  "description": "ذغال‌سنگ کوین - ERC-20 با Merkle Whitelist",
  "scripts": {
    "merkle": "node scripts/merkle-generator.js",
    "serve":  "npx serve frontend -p 3000"
  },
  "dependencies": {
    "@openzeppelin/contracts": "^5.0.0",
    "ethers":       "^5.7.2",
    "keccak256":    "^1.0.6",
    "merkletreejs": "^0.3.11"
  },
  "devDependencies": {
    "serve": "^14.0.0"
  }
}
PKG_EOF

# ─────────────────────────────────────────────────────────
#  .gitignore
# ─────────────────────────────────────────────────────────

cat > .gitignore << 'GIT_EOF'
node_modules/
proofs.json
.env
*.env
artifacts/
cache/
GIT_EOF

# ─────────────────────────────────────────────────────────
#  README
# ─────────────────────────────────────────────────────────

cat > README.md << 'README_EOF'
# ⛏️ ذغال‌سنگ کوین

## ساختار پروژه
