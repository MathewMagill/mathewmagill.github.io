<!doctype html>
<html lang="zh-Hans">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Typing — 你好</title>
    <style>
      :root {
        --ok: #16a34a;
        --bad: #dc2626;
        --fg: #111827;
        --muted: #6b7280;
        --bg: #ffffff;
      }

      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-items: center;
        background: var(--bg);
        color: var(--fg);
        font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial,
          "Noto Sans", "Apple Color Emoji", "Segoe UI Emoji";
      }

      .card {
        width: min(560px, calc(100vw - 32px));
        padding: 28px;
        border: 1px solid #e5e7eb;
        border-radius: 14px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
      }

      .prompt {
        font-size: 56px;
        font-weight: 700;
        letter-spacing: 0.02em;
        text-align: center;
        margin: 0 0 18px;
      }

      .row {
        display: flex;
        align-items: center;
        gap: 10px;
        justify-content: center;
      }

      input[type="text"] {
        font-size: 40px;
        padding: 10px 14px;
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        outline: none;
        width: 9ch;
        text-align: center;
        transition: border-color 120ms ease, color 120ms ease;
      }

      input[type="text"]:focus {
        border-color: #93c5fd;
      }

      input.bad {
        color: var(--bad);
        border-color: rgba(220, 38, 38, 0.55);
      }

      input.good {
        color: var(--fg);
        border-color: rgba(22, 163, 74, 0.55);
      }

      .check {
        font-size: 34px;
        line-height: 1;
        color: var(--ok);
        visibility: hidden;
        user-select: none;
      }

      .check.visible {
        visibility: visible;
      }

      .hint {
        margin-top: 12px;
        text-align: center;
        color: var(--muted);
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <main class="card">
      <h1 class="prompt" aria-label="Prompt">你好</h1>

      <div class="row">
        <label for="hanzi" class="sr-only" style="position:absolute;left:-9999px;">Type 你好</label>
        <input
          id="hanzi"
          type="text"
          inputmode="text"
          autocomplete="off"
          autocapitalize="off"
          autocorrect="off"
          spellcheck="false"
          aria-describedby="hint"
        />
        <span id="check" class="check" aria-label="Correct" title="Correct">✓</span>
      </div>

      <div id="hint" class="hint">Type the Simplified Chinese characters exactly: 你好</div>
    </main>

    <script>
      (function () {
        const target = "你好";
        const input = document.getElementById("hanzi");
        const check = document.getElementById("check");

        // Disable copy/paste/cut and context menu (best-effort).
        const prevent = (e) => {
          e.preventDefault();
          return false;
        };
        ["copy", "paste", "cut", "contextmenu"].forEach((evt) =>
          input.addEventListener(evt, prevent)
        );

        // Prevent Ctrl/Cmd+C/V/X.
        input.addEventListener("keydown", (e) => {
          const key = (e.key || "").toLowerCase();
          const isMod = e.ctrlKey || e.metaKey;
          if (isMod && (key === "c" || key === "v" || key === "x")) {
            e.preventDefault();
          }
        });

        function update() {
          const value = input.value;
          const ok = value === target;

          input.classList.toggle("good", ok);
          input.classList.toggle("bad", value.length > 0 && !ok);

          check.classList.toggle("visible", ok);
        }

        input.addEventListener("input", update);
        update();

        // Focus on load for convenience.
        window.addEventListener("load", () => input.focus());
      })();
    </script>
  </body>
</html>