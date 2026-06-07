# ⛏️ ذغال‌سنگ کوین

پروژه‌ی **CoalCoin** یک نمونه کامل برای پیاده‌سازی توکن ERC-20 با پشتیبانی از whitelist مبتنی بر Merkle Tree و رابط کاربری وب است. این پروژه شامل قرارداد هوشمند، پوسته‌ی فرانت‌اند با اتصال MetaMask، و ابزار تولید Merkle Proof می‌شود.

## ویژگی‌های اصلی

- قرارداد هوشمند ERC-20 با قابلیت سوزاندن توکن (`burn`).
- مینت لیست سفید با **Merkle Proof** و تابع `whitelistMint`.
- مینت عمومی با `publicMint` پس از فعال شدن فروش عمومی.
- انتقال توکن، نمایش موجودی COAL و ETH، و بروزرسانی زنده.
- رابط کاربری راست‌چین با بک‌گراند دیجیتال رین در `frontend/index.html`.
- ابزار تولید Merkle Root و Proof در `scripts/merkle-generator.js`.

## ساختار پروژه

- `contracts/CoalCoin.sol` — قرارداد هوشمند ERC-20 با قابلیت‌های whitelist، public mint، burn، و مدیریت مالک.
- `frontend/index.html` — صفحه‌ی وب اصلی با رابط کاربری و پس‌زمینه‌ی دیجیتال رین.
- `frontend/style.css` — استایل دهی رابط کاربری و افکت پس‌زمینه.
- `frontend/app.js` — منطق اتصال MetaMask، خواندن داده‌ها از قرارداد و ارسال تراکنش.
- `assets/gif/digital-rain.gif` — تصویر پس‌زمینه‌ی دیجیتال.
- `scripts/merkle-generator.js` — ساخت Merkle Tree، Merkle Root و proofs برای whitelist.
- `package.json` — تنظیمات npm، اسکریپت‌ها و وابستگی‌های مورد نیاز.

## توضیح قرارداد هوشمند

قرارداد `CoalCoin.sol` ویژگی‌های زیر را دارد:

- `ERC20`, `ERC20Burnable`, `Ownable`, `ReentrancyGuard`.
- `maxSupply` ثابت برای محدود کردن عرضه کل توکن.
- `mintPrice` قابل تنظیم توسط مالک.
- `whitelistMaxMint` برای تعیین حداکثر تعداد توکن قابل مینت برای whitelist.
- `merkleRoot` برای اعتبارسنجی آدرس‌های whitelist.
- `whitelistMint` با بررسی Merkle Proof و بازپرداخت اضافی ETH.
- `publicMint` فقط زمانی فعال است که مالک فروش عمومی را روشن کند.
- `burn` برای سوزاندن توکن از کیف‌پول کاربر.
- `transfer` استاندارد ERC-20 برای ارسال توکن.
- کنترل مالک برای تغییر Merkle Root، قیمت مینت، فعال/غیرفعال کردن فروش و برداشت ETH.

## توضیح فرانت‌اند

فرانت‌اند این پروژه در `frontend/` قرار دارد و کارهای زیر را انجام می‌دهد:

- اتصال به MetaMask و دریافت آدرس کاربر.
- نمایش موجودی COAL و ETH کاربر.
- نمایش میزان عرضه کل، حداکثر عرضه و قیمت مینت.
- مینت whitelist و مینت عمومی با ارسال تراکنش به قرارداد.
- سوزاندن توکن و انتقال توکن به آدرس دیگر.
- نمایش وضعیت فروش عمومی.
- افکت پس‌زمینه‌ی **digital rain** برای تجربه بصری بهتر.

## اجرای پروژه

1. وابستگی‌ها را نصب کنید:

```bash
npm install
```

2. اگر از اسکریپت Merkle استفاده می‌کنید:

```bash
npm run merkle
```

3. تنظیم آدرس قرارداد را در `frontend/app.js` انجام دهید:

```js
const CONTRACT_ADDRESS = "0x_YOUR_CONTRACT_ADDRESS_HERE";
```

4. پروژه را اجرا کنید:

```bash
npm run serve
```

5. مرورگر را باز کنید و به `http://localhost:3000` بروید.

## ساخت Merkle Root و Proof

فایل `scripts/merkle-generator.js` برای تولید Merkle Root و proofهای whitelist طراحی شده است:

- آدرس‌های whitelist را در آرایه `whitelist` وارد کنید.
- دستور `npm run merkle` را اجرا کنید.
- خروجی شامل `root` و `proofs.json` خواهد بود.
- `root` را در constructor قرارداد قرار دهید یا با تابع `setMerkleRoot` تنظیم کنید.

## نکات مهم

- این پروژه برای محیط توسعه و تست مناسب است و پیش از استفاده در شبکه اصلی باید بررسی امنیتی انجام شود.
- بخش whitelist فقط یک بار به ازای هر آدرس قابل ادعاست (`whitelistClaimed`).
- `publicSaleActive` فقط با دستور مالک روشن یا خاموش می‌شود.
- پس‌زمینه‌ی دیجیتال رین در `frontend/index.html` و `frontend/style.css` تنظیم شده است.

## نکات اجرا برای توسعه‌دهنده

- `frontend/index.html` به صورت RTL طراحی شده و فونت `Press Start 2P` برای حس بازی‌های کلاسیک استفاده می‌شود.
- `frontend/style.css` با استایل مینیمال و افکت دیجیتال رین هماهنگ است.
- `frontend/app.js` با `ethers.js` کار می‌کند و نیاز به MetaMask دارد.

## نتیجه

این پروژه نمونه‌ای از ترکیب قرارداد هوشمند ERC-20 و فرانت‌اند وب با تمرکز روی تجربه کاربری و امنیت اولیه است. `CoalCoin` یک پلتفرم ساده برای مینت، انتقال، و سوزاندن توکن با پشتیبانی whitelist مبتنی بر Merkle Tree ارائه می‌دهد.
