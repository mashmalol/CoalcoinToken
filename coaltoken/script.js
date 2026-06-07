document.addEventListener("DOMContentLoaded", () => {

    const canvas = document.getElementById("digitalRainCanvas");
    const ctx = canvas.getContext("2d");

    function resize() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
    resize();
    window.onresize = resize;

    const characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const fontSize = 18;
    let columns = canvas.width / fontSize;
    let drops = Array(Math.floor(columns)).fill(1);

    function draw() {
        ctx.fillStyle = "rgba(0,0,0,0.05)";
        ctx.fillRect(0,0,canvas.width,canvas.height);

        ctx.fillStyle = "#0F0";
        ctx.font = fontSize + "px Courier";

        drops.forEach((y, i) => {
            const char = characters[Math.floor(Math.random()*characters.length)];
            const x = i * fontSize;
            ctx.fillText(char, x, y * fontSize);

            if (y * fontSize > canvas.height && Math.random() > 0.975)
                drops[i] = 0;

            drops[i]++;
        });
    }
    setInterval(draw, 40);

    /* ---------------- TOKEN BUY ---------------- */
    document.getElementById("buyTokenBtn").onclick = () => {
        const amt = document.getElementById("buyAmount").value;
        alert("در نسخه کامل، این دکمه تراکنش خرید " + amt + " MineToken را اجرا می‌کند.");
    };

    document.getElementById("connectWalletBtn").onclick = () => {
        alert("اتصال واقعی کیف پول بعداً اضافه می‌شود.");
    };

    /* ---------------- TOKEN BURN ---------------- */
    document.getElementById("burnTokenBtn").onclick = () => {
        const amt = document.getElementById("burnAmount").value;
        alert("در نسخه واقعی، " + amt + " MineToken سوزانده می‌شود و رسید دریافت زغال صادر می‌گردد.");
    };

    /* ---------------- EXPLORE MODAL ---------------- */
    const modal = document.getElementById("exploreModal");
    const close = document.querySelector(".close-button");

    document.getElementById("exploreBtn").onclick = () => {
        modal.style.display = "flex";
        loadCoalBundles();
    };

    close.onclick = () => modal.style.display = "none";

    window.onclick = (e) => {
        if (e.target === modal) modal.style.display = "none";
    };

    function loadCoalBundles() {
        const bundles = [
            { name: "بسته ۵۰ کیلویی زغال", img:"https://via.placeholder.com/250x140?text=Coal50", hue:"hue1" },
            { name: "بسته ۱۰۰ کیلویی زغال", img:"https://via.placeholder.com/250x140?text=Coal100", hue:"hue2" },
            { name: "پالت یک تنی زغال", img:"https://via.placeholder.com/250x140?text=Coal1T", hue:"hue3" },
            { name: "پالت دو تنی زغال", img:"https://via.placeholder.com/250x140?text=Coal2T", hue:"hue4" }
        ];

        const container = document.getElementById("tokenCards");
        container.innerHTML = "";

        bundles.forEach((b) => {
            const card = document.createElement("div");
            card.classList.add("token-card", b.hue);

            card.innerHTML = `
                <img src="${b.img}">
                <h3>${b.name}</h3>
                <button class="buy-button">مشاهده جزئیات</button>
            `;
            container.appendChild(card);
        });
    }
});

