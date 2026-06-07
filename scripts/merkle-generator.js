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
