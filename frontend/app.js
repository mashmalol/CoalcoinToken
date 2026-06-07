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
