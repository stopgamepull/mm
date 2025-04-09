<!DOCTYPE html><html lang="ru"><head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MonstrumInstitute</title>
    <link rel="icon" href="images/HLAB.png" type="image/png">
    <style>
      :root {
        --accent: #8e44ad;
        --dark: #0a0a12;
        --darker: #06060e;
        --light: #e6e6e6;
        --fluid: rgba(46, 204, 113, 0.15);
        --panel: #1a1a2e;
        --warning: #f39c12;
        --danger: #e74c3c;
        --safe: #2ecc71;
        --glass: rgba(255, 255, 255, 0.05);
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: "Courier New", monospace;
      }

      body {
        background-color: var(--dark);
        color: var(--light);
        line-height: 1.6;
        overflow-x: hidden;
        background-image: radial-gradient(
            circle at 10% 20%,
            var(--fluid) 0%,
            transparent 20%
          ),
          radial-gradient(circle at 90% 80%, var(--fluid) 0%, transparent 20%);
        background-attachment: fixed;
      }

      header {
        background-color: rgba(10, 10, 18, 0.9);
        padding: 0.8rem;
        border-bottom: 1px solid var(--accent);
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 100;
        backdrop-filter: blur(5px);
      }

      .logo {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 1.3rem;
        font-weight: bold;
        color: var(--light);
        text-decoration: none;
      }

      .logo::before {
        content: "🧪";
        font-size: 1.8rem;
      }

      nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
      }

      .nav-links {
        display: flex;
        gap: 1.5rem;
        align-items: center;
      }

      .nav-links a {
        color: var(--light);
        text-decoration: none;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: color 0.3s;
        position: relative;
        font-weight: bold;
      }

      .nav-links a:hover {
        color: var(--accent);
      }

      .nav-links a::after {
        content: "";
        position: absolute;
        bottom: -5px;
        left: 0;
        width: 0;
        height: 2px;
        background-color: var(--accent);
        transition: width 0.3s;
      }

      .nav-links a:hover::after {
        width: 100%;
      }

      .social-links {
        display: flex;
        gap: 0.8rem;
        margin-left: 1.5rem;
      }

      .social-link {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: var(--glass);
        transition: all 0.3s;
        color: var(--light);
        text-decoration: none;
        font-size: 0.9rem;
      }

      .social-link:hover {
        background-color: var(--accent);
        transform: translateY(-2px);
      }

      .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.8);
        z-index: 1000;
        backdrop-filter: blur(5px);
        justify-content: center;
        align-items: center;
      }

      .modal-content {
        background-color: var(--panel);
        border: 1px solid var(--accent);
        border-radius: 8px;
        width: 80%;
        max-width: 600px;
        max-height: 80vh;
        overflow: hidden;
        position: relative;
        box-shadow: 0 0 30px rgba(142, 68, 173, 0.5);
      }

      .modal-header {
        padding: 1rem;
        background-color: rgba(142, 68, 173, 0.2);
        border-bottom: 1px solid var(--accent);
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .modal-title {
        font-size: 1.2rem;
        color: var(--light);
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      .close-modal {
        background: none;
        border: none;
        color: var(--light);
        font-size: 1.5rem;
        cursor: pointer;
        transition: color 0.3s;
      }

      .close-modal:hover {
        color: var(--danger);
      }

      .modal-body {
        padding: 1.5rem;
        position: relative;
      }

      .dna-visualization {
        width: 100%;
        height: 200px;
        position: relative;
        margin-bottom: 1.5rem;
        overflow: hidden;
      }

      .dna-strand {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 80%;
        height: 100px;
      }

      .dna-node {
        position: absolute;
        width: 12px;
        height: 12px;
        background-color: var(--accent);
        border-radius: 50%;
        animation: pulse 2s infinite;
      }

      .dna-connection {
        position: absolute;
        height: 2px;
        background-color: var(--accent);
        transform-origin: left center;
      }

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
        margin-bottom: 1.5rem;
      }

      .stat-item {
        background-color: rgba(142, 68, 173, 0.1);
        padding: 1rem;
        border-radius: 5px;
        border-left: 3px solid var(--accent);
      }

      .stat-label {
        font-size: 0.7rem;
        color: #aaa;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 0.5rem;
      }

      .stat-value {
        font-size: 1.2rem;
        color: var(--light);
        font-weight: bold;
      }

      .progress-container {
        width: 100%;
        height: 10px;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 5px;
        margin-top: 1rem;
        overflow: hidden;
      }

      .progress-bar {
        height: 100%;
        background: linear-gradient(90deg, var(--accent), #9b59b6);
        border-radius: 5px;
        width: 0;
        transition: width 1s ease;
      }

      .experiment-visual {
        width: 100%;
        height: 150px;
        background: linear-gradient(
          135deg,
          rgba(142, 68, 173, 0.1),
          rgba(46, 204, 113, 0.1)
        );
        border-radius: 5px;
        margin-bottom: 1rem;
        position: relative;
        overflow: hidden;
      }

      .particle {
        position: absolute;
        width: 4px;
        height: 4px;
        background-color: var(--accent);
        border-radius: 50%;
        opacity: 0;
      }

      .modal-footer {
        padding: 1rem;
        background-color: rgba(20, 20, 40, 0.8);
        border-top: 1px solid var(--accent);
        text-align: right;
      }

      .modal-btn {
        background-color: var(--accent);
        color: var(--light);
        border: none;
        padding: 0.5rem 1.2rem;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s;
      }

      .modal-btn:hover {
        background-color: #9b59b6;
        transform: translateY(-2px);
      }

      @keyframes pulse {
        0% {
          transform: scale(1);
          opacity: 0.7;
        }
        50% {
          transform: scale(1.1);
          opacity: 1;
        }
        100% {
          transform: scale(1);
          opacity: 0.7;
        }
      }

      .container {
        max-width: 1200px;
        margin: 6rem auto 2rem;
        padding: 0 1.5rem;
      }

      h1,
      h2,
      h3 {
        font-weight: normal;
      }

      h1 {
        font-size: 2.2rem;
        margin-bottom: 2rem;
        color: var(--light);
        text-align: center;
        position: relative;
        text-transform: uppercase;
        letter-spacing: 2px;
      }

      h1::after {
        content: "";
        display: block;
        width: 150px;
        height: 2px;
        background: linear-gradient(
          90deg,
          transparent,
          var(--accent),
          transparent
        );
        margin: 1rem auto;
      }

      .lab-intro {
        text-align: center;
        margin-bottom: 3rem;
        padding: 1.5rem;
        border: 1px solid var(--accent);
        border-radius: 5px;
        background-color: rgba(20, 20, 40, 0.6);
        position: relative;
        overflow: hidden;
      }

      .lab-intro::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          135deg,
          transparent 60%,
          rgba(142, 68, 173, 0.1) 100%
        );
        pointer-events: none;
      }

      .lab-intro p {
        position: relative;
        z-index: 2;
        font-size: 0.95rem;
        line-height: 1.8;
      }

      .specimens-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 2rem;
        margin-top: 3rem;
      }

      .specimen {
        background-color: var(--panel);
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
        transition: transform 0.3s, box-shadow 0.3s;
        position: relative;
        border: 1px solid rgba(142, 68, 173, 0.3);
      }

      .specimen:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.7);
        border-color: var(--accent);
      }

      .specimen-image {
        height: 280px;
        background-color: #111;
        position: relative;
        overflow: hidden;
        border-bottom: 1px solid var(--accent);
      }

      .capsule {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 180px;
        height: 240px;
        background: linear-gradient(
          to bottom,
          rgba(52, 152, 219, 0.05),
          rgba(155, 89, 182, 0.1)
        );
        border-radius: 50% 50% 45% 45% / 60% 60% 40% 40%;
        border: 2px solid rgba(255, 255, 255, 0.1);
        box-shadow: inset 0 0 30px rgba(255, 255, 255, 0.1),
          0 0 40px rgba(52, 152, 219, 0.2);
        display: flex;
        justify-content: center;
        align-items: center;
      }

      .capsule::before {
        content: "";
        position: absolute;
        top: 5%;
        left: 5%;
        right: 5%;
        bottom: 5%;
        border: 1px dashed rgba(255, 255, 255, 0.1);
        border-radius: 50% 50% 45% 45% / 60% 60% 40% 40%;
        pointer-events: none;
      }

      .humanoid {
        position: relative;
        width: 100px;
        height: 160px;
        background-color: rgba(255, 255, 255, 0.05);
        border-radius: 40% 40% 35% 35% / 50% 50% 30% 30%;
        animation: float 4s ease-in-out infinite;
        box-shadow: inset 0 0 20px rgba(255, 255, 255, 0.1);
      }

      .humanoid::before {
        content: "";
        position: absolute;
        top: 15%;
        left: 50%;
        transform: translateX(-50%);
        width: 30px;
        height: 30px;
        background-color: rgba(255, 255, 255, 0.05);
        border-radius: 50%;
      }

      .bubbles {
        position: absolute;
        bottom: 0;
        width: 100%;
        height: 100%;
      }

      .bubble {
        position: absolute;
        background-color: rgba(255, 255, 255, 0.15);
        border-radius: 50%;
        animation: rise 6s infinite;
        filter: blur(0.5px);
      }

      @keyframes float {
        0%,
        100% {
          transform: translate(-50%, -50%) translateY(0);
        }
        50% {
          transform: translate(-50%, -50%) translateY(-10px);
        }
      }

      @keyframes rise {
        0% {
          transform: translateY(0) scale(0.3);
          opacity: 0;
        }
        10% {
          opacity: 0.5;
        }
        100% {
          transform: translateY(-250px) scale(1.5);
          opacity: 0;
        }
      }

      .specimen-info {
        padding: 1.5rem;
        position: relative;
      }

      .specimen-info h3 {
        font-size: 1.4rem;
        margin-bottom: 0.5rem;
        color: var(--light);
        font-weight: bold;
        letter-spacing: 0.5px;
      }

      .specimen-info .era {
        display: inline-block;
        background-color: rgba(142, 68, 173, 0.3);
        padding: 0.3rem 0.8rem;
        border-radius: 15px;
        font-size: 0.75rem;
        margin-bottom: 1rem;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      .specimen-info p {
        font-size: 0.9rem;
        margin-bottom: 1.2rem;
        color: #aaa;
        line-height: 1.7;
      }

      .status {
        display: flex;
        align-items: center;
        font-size: 0.8rem;
        margin-top: 1rem;
        padding-top: 1rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      .status-indicator {
        width: 12px;
        height: 12px;
        border-radius: 50%;
        margin-right: 0.7rem;
        position: relative;
      }

      .status-indicator::after {
        content: "";
        position: absolute;
        top: -3px;
        left: -3px;
        right: -3px;
        bottom: -3px;
        border-radius: 50%;
        opacity: 0.5;
        animation: pulse 2s infinite;
      }

      .alive {
        background-color: var(--safe);
      }

      .alive::after {
        background-color: var(--safe);
      }

      .experimenting {
        background-color: var(--warning);
      }

      .experimenting::after {
        background-color: var(--warning);
      }

      .terminated {
        background-color: var(--danger);
      }

      .terminated::after {
        background-color: var(--danger);
      }

      @keyframes pulse {
        0% {
          transform: scale(0.8);
          opacity: 0.5;
        }
        50% {
          transform: scale(1.2);
          opacity: 0.2;
        }
        100% {
          transform: scale(0.8);
          opacity: 0.5;
        }
      }

      .specimen-details {
        display: flex;
        justify-content: space-between;
        margin-top: 1rem;
        font-size: 0.75rem;
        color: #777;
      }

      .experiment-section {
        margin-top: 5rem;
        padding: 2.5rem;
        background-color: rgba(20, 20, 40, 0.7);
        border-radius: 8px;
        border: 1px solid var(--accent);
        position: relative;
        overflow: hidden;
      }

      .experiment-section::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(
            135deg,
            transparent 60%,
            rgba(142, 68, 173, 0.1) 100%
          ),
          url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect fill="%231a1a2e" width="50" height="50" x="0" y="0"/><rect fill="%231a1a2e" width="50" height="50" x="50" y="50"/></svg>');
        background-size: 10px 10px;
        opacity: 0.1;
        pointer-events: none;
      }

      .experiment-section h2 {
        color: var(--light);
        margin-bottom: 2rem;
        text-align: center;
        font-size: 1.8rem;
        text-transform: uppercase;
        letter-spacing: 2px;
        position: relative;
        z-index: 2;
      }

      .experiment-section h2::after {
        content: "";
        display: block;
        width: 150px;
        height: 2px;
        background: linear-gradient(
          90deg,
          transparent,
          var(--accent),
          transparent
        );
        margin: 1rem auto;
      }

      .experiment-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 1.8rem;
        position: relative;
        z-index: 2;
      }

      .experiment-card {
        background-color: rgba(30, 30, 60, 0.7);
        padding: 1.8rem;
        border-radius: 5px;
        transition: all 0.3s;
        border: 1px solid rgba(142, 68, 173, 0.2);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        position: relative;
        overflow: hidden;
      }

      .experiment-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
        border-color: var(--accent);
        background-color: rgba(40, 40, 80, 0.7);
      }

      .experiment-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 3px;
        height: 100%;
        background: linear-gradient(
          to bottom,
          transparent,
          var(--accent),
          transparent
        );
      }

      .experiment-card h3 {
        color: var(--warning);
        margin-bottom: 1rem;
        font-size: 1.1rem;
        position: relative;
        padding-left: 1.5rem;
      }

      .experiment-card h3::before {
        content: "⚗️";
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        font-size: 1rem;
      }

      .experiment-card p {
        font-size: 0.85rem;
        color: #bbb;
        line-height: 1.7;
      }

      .lab-equipment {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        pointer-events: none;
        z-index: 1;
        opacity: 0.1;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" stroke="%238e44ad" stroke-width="1" fill="none"/><line x1="10" y1="50" x2="90" y2="50" stroke="%238e44ad" stroke-width="1"/><line x1="50" y1="10" x2="50" y2="90" stroke="%238e44ad" stroke-width="1"/></svg>'),
          url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><path d="M20,20 L80,20 L80,80 L20,80 Z" stroke="%238e44ad" stroke-width="1" fill="none"/><path d="M30,30 L70,30 L70,70 L30,70 Z" stroke="%238e44ad" stroke-width="1" fill="none"/></svg>');
        background-repeat: no-repeat;
        background-position: 20% 30%, 80% 70%;
        background-size: 100px 100px, 80px 80px;
      }

      footer {
        background-color: rgba(10, 10, 18, 0.9);
        padding: 3rem 1rem 2rem;
        text-align: center;
        margin-top: 5rem;
        border-top: 1px solid var(--accent);
        position: relative;
        backdrop-filter: blur(5px);
      }

      .footer-links {
        display: flex;
        justify-content: center;
        gap: 2rem;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
      }

      .footer-links a {
        color: var(--light);
        text-decoration: none;
        font-size: 0.8rem;
        transition: color 0.3s;
        text-transform: uppercase;
        letter-spacing: 1px;
        position: relative;
      }

      .footer-links a::after {
        content: "";
        position: absolute;
        bottom: -3px;
        left: 0;
        width: 0;
        height: 1px;
        background-color: var(--accent);
        transition: width 0.3s;
      }

      .footer-links a:hover {
        color: var(--accent);
      }

      .footer-links a:hover::after {
        width: 100%;
      }

      .copyright {
        font-size: 0.75rem;
        color: #777;
        margin-top: 1rem;
      }

      .warning-stripes {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 10px;
        background: repeating-linear-gradient(
          45deg,
          transparent,
          transparent 10px,
          var(--warning) 10px,
          var(--warning) 20px
        );
        opacity: 0.3;
      }

      /* Анимация сканирования */
      .scan-line {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 2px;
        background: linear-gradient(
          to right,
          transparent,
          rgba(46, 204, 113, 0.5),
          transparent
        );
        animation: scan 8s linear infinite;
        z-index: 3;
        pointer-events: none;
      }

      @keyframes scan {
        0% {
          top: 0;
          opacity: 0;
        }
        5% {
          opacity: 1;
        }
        95% {
          opacity: 1;
        }
        100% {
          top: 100%;
          opacity: 0;
        }
      }

      /* Консольные элементы */
      .console-panel {
        background-color: rgba(0, 0, 0, 0.7);
        border: 1px solid var(--accent);
        border-radius: 5px;
        padding: 1rem;
        margin-top: 2rem;
        font-family: "Courier New", monospace;
        font-size: 0.85rem;
        line-height: 1.6;
        color: #0f0;
        position: relative;
        overflow: hidden;
      }

      .console-panel::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(rgba(0, 255, 0, 0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(0, 255, 0, 0.03) 1px, transparent 1px);
        background-size: 20px 20px;
        pointer-events: none;
      }

      .console-line {
        margin-bottom: 0.5rem;
      }

      .console-prompt {
        color: #0f0;
      }

      .typing-text {
        display: inline-block;
        overflow: hidden;
        border-right: 2px solid #0f0;
        white-space: nowrap;
        margin: 0 auto;
        letter-spacing: 1px;
        animation: blink-caret 0.75s step-end infinite;
      }

      @keyframes blink-caret {
        from,
        to {
          border-color: transparent;
        }
        50% {
          border-color: #0f0;
        }
      }

      /* Адаптивность */
      @media (max-width: 768px) {
        .specimens-grid {
          grid-template-columns: 1fr;
        }

        .nav-links {
          gap: 1rem;
          font-size: 0.7rem;
        }

        .container {
          margin-top: 5rem;
          padding: 0 1rem;
        }

        .experiment-section {
          padding: 1.5rem;
        }
      }
    </style>
  </head>
  <body>
    <div class="warning-stripes"></div>
    <div class="scan-line"></div>

    <!-- Модальные окна -->
    <!-- Модальное окно SPECIMENS -->
    <div id="specimensModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="modal-title">SPECIMEN DATABASE</span>
          <button class="close-modal">�</button>
        </div>
        <div class="modal-body">
          <div class="dna-visualization">
            <!-- Анимированная спираль ДНК -->
            <div class="dna-strand"></div>
          </div>

          <div class="specimen-stats">
            <div class="stat-item">
              <div class="stat-value glowing" id="activeSpecimens">14</div>
              <div class="stat-label">ACTIVE SPECIMENS</div>
            </div>
            <div class="stat-item">
              <div class="stat-value glowing" id="containedSpecimens">92%</div>
              <div class="stat-label">CONTAINMENT</div>
            </div>
          </div>

          <div class="specimen-progress">
            <div class="progress-label">SPECIMEN VITALITY</div>
            <div class="progress-container">
              <div class="progress-bar" style="width: 78%"></div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn scan-btn">INITIATE FULL SCAN</button>
          <button class="modal-btn">TERMINATE PROTOCOL</button>
        </div>
      </div>
    </div>

    <!-- Модальное окно EXPERIMENTS -->
    <div id="experimentsModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="modal-title">EXPERIMENT CONTROL</span>
          <button class="close-modal">�</button>
        </div>
        <div class="modal-body">
          <div class="experiment-visual">
            <!-- Анимированные частицы -->
            <div class="particles-container"></div>
          </div>

          <div class="experiment-controls">
            <div class="control-group">
              <label>NEURAL STIMULATION</label>
              <input type="range" min="0" max="100" value="45" class="slider">
            </div>
            <div class="control-group">
              <label>NUTRIENT FLOW</label>
              <input type="range" min="0" max="100" value="72" class="slider">
            </div>
          </div>

          <div class="experiment-status">
            <div class="status-item warning">
              <span>WARNING: SPECIMEN H-532 SHOWING SIGNS OF DISTRESS</span>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn emergency">EMERGENCY STOP</button>
          <button class="modal-btn">ADJUST PARAMETERS</button>
        </div>
      </div>
    </div>

    <!-- Модальное окно RESEARCH -->
    <div id="researchModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="modal-title">RESEARCH TERMINAL</span>
          <button class="close-modal">�</button>
        </div>
        <div class="modal-body">
          <div class="research-grid">
            <div class="research-item">
              <div class="research-icon">🧬</div>
              <div class="research-title">GENOME MAPPING</div>
              <div class="research-progress">87%</div>
            </div>
            <div class="research-item">
              <div class="research-icon">🧠</div>
              <div class="research-title">NEURAL LINKING</div>
              <div class="research-progress">42%</div>
            </div>
            <div class="research-item">
              <div class="research-icon">💪</div>
              <div class="research-title">MUSCLE ENHANCEMENT</div>
              <div class="research-progress">65%</div>
            </div>
          </div>

          <div class="research-console">
            <div class="console-line">
              > Analyzing specimen H-219 brain patterns...
            </div>
            <div class="console-line">
              > Detecting unusual activity in prefrontal cortex
            </div>
            <div class="console-line">
              > Recommendation: increase dopamine levels by 15%
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn">DOWNLOAD DATA</button>
          <button class="modal-btn">UPLOAD NEW PROTOCOL</button>
        </div>
      </div>
    </div>

    <!-- Модальное окно FACILITY -->
    <div id="facilityModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="modal-title">FACILITY OVERVIEW</span>
          <button class="close-modal">�</button>
        </div>
        <div class="modal-body">
          <div class="facility-map">
            <div class="map-grid">
              <div class="map-cell lab">LAB 1</div>
              <div class="map-cell lab">LAB 2</div>
              <div class="map-cell quarantine">QUARANTINE</div>
              <div class="map-cell storage">STORAGE</div>
              <div class="map-cell control">CONTROL ROOM</div>
              <div class="map-cell lab warning">LAB 3</div>
            </div>
          </div>

          <div class="facility-status">
            <div class="status-item">
              <span class="status-indicator green"></span>
              <span>POWER: 98%</span>
            </div>
            <div class="status-item">
              <span class="status-indicator yellow"></span>
              <span>SECURITY: 82%</span>
            </div>
            <div class="status-item">
              <span class="status-indicator red"></span>
              <span>LAB 3: CONTAINMENT BREACH</span>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn alert">LOCKDOWN FACILITY</button>
          <button class="modal-btn">EVACUATE STAFF</button>
        </div>
      </div>
    </div>

    <!-- Модальное окно SECURITY -->
    <div id="securityModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <span class="modal-title">SECURITY TERMINAL</span>
          <button class="close-modal">�</button>
        </div>
        <div class="modal-body">
          <div class="security-cameras">
            <div class="camera-view" style="background-image: url('https://example.com/cam1.jpg')">
              <div class="camera-label">CORRIDOR A</div>
            </div>
            <div class="camera-view warning" style="background-image: url('https://example.com/cam2.jpg')">
              <div class="camera-label">LAB 3 ENTRANCE</div>
              <div class="camera-alert">MOVEMENT DETECTED</div>
            </div>
          </div>

          <div class="security-controls">
            <div class="control-item">
              <button class="security-btn">ACTIVATE TURRETS</button>
            </div>
            <div class="control-item">
              <button class="security-btn">RELEASE NEUROTOXIN</button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="modal-btn danger">PURGE SECTOR</button>
          <button class="modal-btn">CALL REINFORCEMENTS</button>
        </div>
      </div>
    </div>

    <style>
      /* Стили для модальных окон */
      .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.9);
        z-index: 1000;
        backdrop-filter: blur(5px);
        justify-content: center;
        align-items: center;
      }

      .modal-content {
        background-color: var(--panel);
        border: 1px solid var(--accent);
        border-radius: 8px;
        width: 90%;
        max-width: 700px;
        max-height: 80vh;
        overflow: hidden;
        position: relative;
        box-shadow: 0 0 30px rgba(142, 68, 173, 0.5);
        animation: modalFadeIn 0.3s ease-out;
      }

      @keyframes modalFadeIn {
        from {
          opacity: 0;
          transform: translateY(-50px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .modal-header {
        padding: 1rem;
        background-color: rgba(142, 68, 173, 0.2);
        border-bottom: 1px solid var(--accent);
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .modal-title {
        font-size: 1.2rem;
        color: var(--light);
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      .close-modal {
        background: none;
        border: none;
        color: var(--light);
        font-size: 1.5rem;
        cursor: pointer;
        transition: color 0.3s;
      }

      .close-modal:hover {
        color: var(--danger);
      }

      .modal-body {
        padding: 1.5rem;
        position: relative;
      }

      /* Специфичные стили для каждого модального окна */
      /* Specimens Modal */
      .dna-visualization {
        width: 100%;
        height: 200px;
        position: relative;
        margin-bottom: 1.5rem;
        overflow: hidden;
      }

      .dna-strand {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 80%;
        height: 100px;
        background: repeating-linear-gradient(
          to right,
          transparent,
          transparent 15px,
          var(--accent) 15px,
          var(--accent) 30px
        );
      }

      .specimen-stats {
        display: flex;
        justify-content: space-around;
        margin-bottom: 1.5rem;
      }

      .stat-item {
        text-align: center;
      }

      .stat-value {
        font-size: 2rem;
        color: var(--light);
        margin-bottom: 0.5rem;
      }

      .glowing {
        text-shadow: 0 0 10px var(--accent);
      }

      .stat-label {
        font-size: 0.8rem;
        color: #aaa;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      /* Experiments Modal */
      .experiment-visual {
        width: 100%;
        height: 200px;
        background-color: rgba(0, 0, 0, 0.3);
        margin-bottom: 1.5rem;
        position: relative;
        overflow: hidden;
      }

      .particles-container {
        position: absolute;
        width: 100%;
        height: 100%;
      }

      .experiment-controls {
        margin-bottom: 1.5rem;
      }

      .control-group {
        margin-bottom: 1rem;
      }

      .control-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-size: 0.8rem;
        color: #aaa;
      }

      .slider {
        width: 100%;
        height: 5px;
        -webkit-appearance: none;
        background: rgba(255, 255, 255, 0.1);
        outline: none;
        border-radius: 5px;
      }

      .slider::-webkit-slider-thumb {
        -webkit-appearance: none;
        width: 15px;
        height: 15px;
        background: var(--accent);
        cursor: pointer;
        border-radius: 50%;
      }

      /* Research Modal */
      .research-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
        margin-bottom: 1.5rem;
      }

      .research-item {
        background-color: rgba(142, 68, 173, 0.1);
        padding: 1rem;
        border-radius: 5px;
        text-align: center;
      }

      .research-icon {
        font-size: 2rem;
        margin-bottom: 0.5rem;
      }

      .research-title {
        font-size: 0.7rem;
        color: #aaa;
        margin-bottom: 0.5rem;
      }

      .research-progress {
        font-size: 0.9rem;
        color: var(--light);
      }

      .research-console {
        background-color: rgba(0, 0, 0, 0.3);
        padding: 1rem;
        border-radius: 5px;
        font-family: "Courier New", monospace;
        font-size: 0.8rem;
        line-height: 1.6;
      }

      /* Facility Modal */
      .facility-map {
        margin-bottom: 1.5rem;
      }

      .map-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 0.5rem;
      }

      .map-cell {
        padding: 1rem;
        text-align: center;
        border-radius: 5px;
        font-size: 0.8rem;
        background-color: rgba(142, 68, 173, 0.1);
      }

      .map-cell.lab {
        background-color: rgba(46, 204, 113, 0.1);
      }

      .map-cell.quarantine {
        background-color: rgba(231, 76, 60, 0.1);
      }

      .map-cell.control {
        background-color: rgba(52, 152, 219, 0.1);
      }

      .map-cell.warning {
        border: 1px solid var(--danger);
        animation: pulseWarning 1s infinite;
      }

      @keyframes pulseWarning {
        0%,
        100% {
          opacity: 1;
        }
        50% {
          opacity: 0.5;
        }
      }

      .facility-status {
        margin-top: 1rem;
      }

      .status-item {
        display: flex;
        align-items: center;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
      }

      .status-indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        margin-right: 0.5rem;
      }

      .status-indicator.green {
        background-color: var(--safe);
      }

      .status-indicator.yellow {
        background-color: var(--warning);
      }

      .status-indicator.red {
        background-color: var(--danger);
      }

      /* Security Modal */
      .security-cameras {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
        margin-bottom: 1.5rem;
      }

      .camera-view {
        height: 150px;
        background-size: cover;
        background-position: center;
        position: relative;
        border-radius: 5px;
        overflow: hidden;
      }

      .camera-view::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
      }

      .camera-view.warning::before {
        background: linear-gradient(transparent, rgba(231, 76, 60, 0.5));
      }

      .camera-label {
        position: absolute;
        bottom: 0;
        left: 0;
        padding: 0.5rem;
        font-size: 0.8rem;
        color: white;
      }

      .camera-alert {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        padding: 0.3rem;
        background-color: var(--danger);
        color: white;
        font-size: 0.7rem;
        text-align: center;
        text-transform: uppercase;
      }

      .security-controls {
        display: flex;
        justify-content: space-around;
        margin-bottom: 1rem;
      }

      .security-btn {
        background-color: rgba(231, 76, 60, 0.2);
        border: 1px solid var(--danger);
        color: var(--light);
        padding: 0.5rem 1rem;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.8rem;
        transition: all 0.3s;
      }

      .security-btn:hover {
        background-color: rgba(231, 76, 60, 0.5);
      }

      /* Общие стили для всех модальных окон */
      .modal-footer {
        padding: 1rem;
        background-color: rgba(20, 20, 40, 0.8);
        border-top: 1px solid var(--accent);
        text-align: right;
      }

      .modal-btn {
        background-color: var(--accent);
        color: var(--light);
        border: none;
        padding: 0.5rem 1.2rem;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s;
        margin-left: 0.5rem;
      }

      .modal-btn:hover {
        background-color: #9b59b6;
        transform: translateY(-2px);
      }

      .modal-btn.emergency {
        background-color: var(--danger);
      }

      .modal-btn.alert {
        background-color: var(--warning);
        color: var(--dark);
      }

      .modal-btn.danger {
        background-color: var(--danger);
      }

      .modal-btn.scan-btn {
        background-color: var(--safe);
        color: var(--dark);
      }

      /* Основной стиль для WebKit-браузеров (Chrome, Edge, Safari) */
      ::-webkit-scrollbar {
        width: 12px;
      }

      ::-webkit-scrollbar-track {
        background: #1e1e2f; /* Темный трек */
      }

      ::-webkit-scrollbar-thumb {
        background-color: #8e44ad; /* Фиолетовый ползунок */
        border-radius: 6px;
        border: 2px solid #1e1e2f; /* Чтобы был небольшой отступ */
      }

      /* Firefox (ограниченная кастомизация) */
      * {
        scrollbar-width: thin;
        scrollbar-color: #8e44ad #1e1e2f;
      }
    </style>

    <script>
      // Функции для управления модальными окнами
      function openModal(modalId) {
        document.getElementById(modalId).style.display = "flex";
        document.body.style.overflow = "hidden"; // Запрещаем прокрутку страницы

        // Запускаем специфичные анимации для каждого модального окна
        switch (modalId) {
          case "specimensModal":
            animateDNA();
            break;
          case "experimentsModal":
            createParticles();
            break;
          case "researchModal":
            animateResearchConsole();
            break;
          case "facilityModal":
            // Никаких специальных анимаций
            break;
          case "securityModal":
            // Никаких специальных анимаций
            break;
        }
      }

      function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
        document.body.style.overflow = "auto"; // Возвращаем прокрутку страницы
      }

      // Закрытие при клике вне модального окна
      window.addEventListener("click", function (event) {
        if (event.target.classList.contains("modal")) {
          closeModal(event.target.id);
        }
      });

      // Анимация ДНК для окна SPECIMENS
      function animateDNA() {
        const dnaStrand = document.querySelector(".dna-strand");
        dnaStrand.style.animation = "dnaFloat 3s ease-in-out infinite";
      }

      // Создание частиц для окна EXPERIMENTS
      function createParticles() {
        const container = document.querySelector(".particles-container");
        container.innerHTML = "";

        for (let i = 0; i < 30; i++) {
          const particle = document.createElement("div");
          particle.className = "particle";
          particle.style.left = `${Math.random() * 100}%`;
          particle.style.top = `${Math.random() * 100}%`;
          particle.style.width = `${Math.random() * 6 + 2}px`;
          particle.style.height = particle.style.width;
          particle.style.animationDelay = `${Math.random() * 5}s`;
          particle.style.animationDuration = `${Math.random() * 3 + 2}s`;

          const colors = [
            "#8e44ad",
            "#2ecc71",
            "#f39c12",
            "#e74c3c",
            "#3498db",
          ];
          particle.style.backgroundColor =
            colors[Math.floor(Math.random() * colors.length)];

          container.appendChild(particle);
        }
      }

      // Анимация консоли для окна RESEARCH
      function animateResearchConsole() {
        const consoleLines = document.querySelectorAll(
          ".research-console .console-line"
        );
        let delay = 0;

        consoleLines.forEach((line) => {
          line.style.opacity = "0";
          setTimeout(() => {
            line.style.transition = "opacity 0.5s ease";
            line.style.opacity = "1";
          }, delay);
          delay += 500;
        });
      }

      // Назначение обработчиков событий для кнопок навбара
      document
        .getElementById("specimensLink")
        .addEventListener("click", function (e) {
          e.preventDefault();
          openModal("specimensModal");
        });

      document
        .getElementById("experimentsLink")
        .addEventListener("click", function (e) {
          e.preventDefault();
          openModal("experimentsModal");
        });

      document
        .getElementById("researchLink")
        .addEventListener("click", function (e) {
          e.preventDefault();
          openModal("researchModal");
        });

      document
        .getElementById("facilityLink")
        .addEventListener("click", function (e) {
          e.preventDefault();
          openModal("facilityModal");
        });

      document
        .getElementById("securityLink")
        .addEventListener("click", function (e) {
          e.preventDefault();
          openModal("securityModal");
        });

      // Назначение обработчиков событий для кнопок закрытия
      document.querySelectorAll(".close-modal").forEach((button) => {
        button.addEventListener("click", function () {
          const modalId = this.closest(".modal").id;
          closeModal(modalId);
        });
      });
    </script>

    <header>
      <nav>
        <a href="#" class="logo">HUMANOID LABORATORY</a>
        <div class="nav-links">
          <a href="#" id="specimensLink">SPECIMENS</a>
          <a href="#" id="experimentsLink">EXPERIMENTS</a>
          <a href="#" id="researchLink">RESEARCH</a>
          <a href="#" id="facilityLink">FACILITY</a>
          <a href="#" id="securityLink">SECURITY</a>
          <div class="social-links">
            <a href="https://x.com/Humanoid_Lab" class="social-link" target="_blank">𝕏</a>
          </div>
        </div>
      </nav>
    </header>

    <div class="container">
      <h1>Specimen Containment</h1>

      <div class="lab-intro">
        <div class="lab-equipment"></div>
        <p>WARNING: CLASSIFIED FACILITY - AUTHORIZED PERSONNEL ONLY</p>
        <p>
          HumanoidLab operates under Directive 7-12 of the Animal Research
          Ethics Board. All specimens are grown in controlled environments and
          monitored 24/7. Unauthorized interaction with specimens is strictly
          prohibited and will result in immediate termination.
        </p>
      </div>

      <div class="console-panel">
        <div class="console-line">
          <span class="console-prompt">> </span><span id="typing-text"></span>
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Biocapsule integrity: 100%
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Life support systems: NOMINAL
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Security protocols: ACTIVE
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Loading specimen database...
        </div>
      </div>

      <div class="specimens-grid">
        <!-- Образец 1 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/1.png" alt="">
            </div>
            <div class="specimen-label">H-782</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-782</h3>
            <span class="era">Neolithic Era</span>
            <p>
              Subject #01 is kept in stasis. Scientists test his brain with
              electric signals to study ancient memory patterns. They also
              inject scarab DNA into his spine to see how it reacts. He shows
              strange dreams on the monitors.
            </p>
            <div class="specimen-details">
              <span>AGE: 12 cycles</span>
              <span>MASS: 68kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>EXPERIMENT IN PROGRESS</span>
            </div>
          </div>
        </div>

        <!-- Образец 2 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/2.png" alt="">
            </div>
            <div class="specimen-label">H-451</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-451</h3>
            <span class="era">Roman Empire</span>
            <p>
              Subject #02 is used in aggression tests. His reptile genes make
              him violent. The lab makes him fight virtual enemies to measure
              control. They also test pain limits with light shocks and record
              his healing speed.
            </p>
            <div class="specimen-details">
              <span>AGE: 8 cycles</span>
              <span>MASS: 75kg</span>
            </div>
            <div class="status">
              <div class="status-indicator alive"></div>
              <span>STABLE CONDITION</span>
            </div>
          </div>
        </div>

        <!-- Образец 3 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/3.png" alt="">
            </div>
            <div class="specimen-label">H-906</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-906</h3>
            <span class="era">Victorian Era</span>
            <p>
              Subject #03 is part of armor-skin experiments. His skin is very
              hard, like metal. Scientists use drills to test how much pressure
              he can take. They study his lion DNA to understand fear and
              loyalty.
            </p>
            <div class="specimen-details">
              <span>AGE: 15 cycles</span>
              <span>MASS: 62kg</span>
            </div>
            <div class="status">
              <div class="status-indicator terminated"></div>
              <span>TERMINATED</span>
            </div>
          </div>
        </div>

        <!-- Образец 4 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/4.png" alt="">
            </div>
            <div class="specimen-label">H-219</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-219</h3>
            <span class="era">21st Century</span>
            <p>
              Subject #04 is used in creativity experiments. Electrodes are
              placed on his brain to see how he creates images without hands.
              Paint drips from his brush-arm even when he sleeps. The lab calls
              this "dream ink."
            </p>
            <div class="specimen-details">
              <span>AGE: 5 cycles</span>
              <span>MASS: 58kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>DATA COLLECTION</span>
            </div>
          </div>
        </div>

        <!-- Образец 5 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/5.png" alt="">
            </div>
            <div class="specimen-label">H-532</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-532</h3>
            <span class="era">Medieval Period</span>
            <p>
              Subject #05 goes through strength tests. Machines pull his limbs
              to measure power. His organs are monitored because they glow
              sometimes. The lab added extra ears to study how sound affects
              rage.
            </p>
            <div class="specimen-details">
              <span>AGE: 10 cycles</span>
              <span>MASS: 70kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>CONTAINMENT PROTOCOL</span>
            </div>
          </div>
        </div>

        <!-- Образец 6 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/6.png" alt="">
            </div>
            <div class="specimen-label">H-777</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-777</h3>
            <span class="era">Future Prototype</span>
            <p>
              Subject #06 is tested with pressure and temperature changes. Steam
              builds up in his body and is released like a machine. The lab
              checks if his brain still follows old manners. He bows to cameras.
            </p>
            <div class="specimen-details">
              <span>AGE: 3 cycles</span>
              <span>MASS: 65kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>HIGH RISK RESEARCH</span>
            </div>
          </div>
        </div>
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/7.png" alt="">
            </div>
            <div class="specimen-label">H-219</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-219</h3>
            <span class="era">21st Century</span>
            <p>
              Subject #07 is used in zero-gravity simulations. His jelly body
              changes shape in space-like tanks. The lab studies his memory loss
              and strange Russian whispers. They say he sings to himself
              sometimes.
            </p>
            <div class="specimen-details">
              <span>AGE: 5 cycles</span>
              <span>MASS: 58kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>DATA COLLECTION</span>
            </div>
          </div>
        </div>

        <!-- Образец 5 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/8.png" alt="">
            </div>
            <div class="specimen-label">H-532</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-532</h3>
            <span class="era">Medieval Period</span>
            <p>
              Subject #09 is part of a data-transfer program. His chest chip is
              connected to the lab's mainframe. They upload different
              personalities into him. Sometimes he glitches and speaks old
              languages from the internet.
            </p>
            <div class="specimen-details">
              <span>AGE: 10 cycles</span>
              <span>MASS: 70kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>CONTAINMENT PROTOCOL</span>
            </div>
          </div>
        </div>

        <!-- Образец 6 -->
        <div class="specimen">
          <div class="specimen-image">
            <div class="capsule">
              <div class="humanoid"></div>
              <div class="bubbles"></div>
              <img style="width: 150%; height: 150%; object-fit: contain" src="images/9.png" alt="">
            </div>
            <div class="specimen-label">H-777</div>
          </div>
          <div class="specimen-info">
            <h3>SPECIMEN H-777</h3>
            <span class="era">Future Prototype</span>
            <p>
              Genetically engineered humanoid with theoretical future
              adaptations. Unstable but promising results in extreme environment
              tests.
            </p>
            <div class="specimen-details">
              <span>AGE: 3 cycles</span>
              <span>MASS: 65kg</span>
            </div>
            <div class="status">
              <div class="status-indicator experimenting"></div>
              <span>HIGH RISK RESEARCH</span>
            </div>
          </div>
        </div>
      </div>

      <div class="experiment-section">
        <div class="lab-equipment"></div>
        <h2>Active Experiments</h2>
        <div class="experiment-grid">
          <div class="experiment-card">
            <h3>Cognitive Rewiring</h3>
            <p>
              Rewiring human neural pathways to process information like aquatic
              mammals. Current success rate: 42%.
            </p>
          </div>
          <div class="experiment-card">
            <h3>Retro-virus Immunity</h3>
            <p>
              Injecting ancient pathogens into modern specimens to study immune
              system evolution. Phase 3 trials ongoing.
            </p>
          </div>
          <div class="experiment-card">
            <h3>Time Perception</h3>
            <p>
              Altering human circadian rhythms to match nocturnal predators.
              Significant progress with specimen H-451.
            </p>
          </div>
          <div class="experiment-card">
            <h3>Social Hierarchy</h3>
            <p>
              Observing human group dynamics under primate dominance structures.
              Unexpected aggression in 67% of subjects.
            </p>
          </div>
        </div>
      </div>

      <div class="console-panel">
        <div class="console-line">
          <span class="console-prompt">> </span>Security scan complete: no
          anomalies detected
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Next maintenance cycle: 12 hours
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Warning: specimen H-532 showing
          unusual biomarkers
        </div>
        <div class="console-line">
          <span class="console-prompt">> </span>Containment protocols reinforced
        </div>
      </div>
    </div>

    <footer>
      <p class="copyright">
        © 2025 HUMAN RESEARCH ANIMAL BOARD | ALL RIGHTS RESERVED
      </p>
      <p class="copyright">UNAUTHORIZED ACCESS WILL BE MET WITH LETHAL FORCE</p>
    </footer>

    <script>
      // Печатающийся эффект для текста "System initialized... Running diagnostics"
      function typeWriter(text, element, speed) {
        let i = 0;
        function typing() {
          if (i < text.length) {
            element.innerHTML += text.charAt(i);
            i++;
            setTimeout(typing, speed);
          } else {
            element.classList.remove("typing-text");
          }
        }
        element.classList.add("typing-text");
        typing();
      }

      // Инициализация печатающегося эффекта
      document.addEventListener("DOMContentLoaded", function () {
        const typingText = document.getElementById("typing-text");
        const text = "System initialized... Running diagnostics";
        typeWriter(text, typingText, 50);
      });

      // Модальные окна
      const modals = {
        specimens: document.getElementById("specimensModal"),
        experiments: document.getElementById("experimentsModal"),
        research: document.getElementById("researchModal"),
        facility: document.getElementById("facilityModal"),
        security: document.getElementById("securityModal"),
      };

      const links = {
        specimens: document.getElementById("specimensLink"),
        experiments: document.getElementById("experimentsLink"),
        research: document.getElementById("researchLink"),
        facility: document.getElementById("facilityLink"),
        security: document.getElementById("securityLink"),
      };

      // Открытие модальных окон
      Object.keys(links).forEach((key) => {
        links[key].addEventListener("click", function (e) {
          e.preventDefault();
          modals[key].style.display = "flex";
          createDNAVisualization(
            `dnaVisualization${
              key === "specimens"
                ? ""
                : key === "experiments"
                ? "2"
                : key === "research"
                ? "3"
                : key === "facility"
                ? "4"
                : "5"
            }`
          );
          createParticles(
            `experimentVisual${
              key === "specimens"
                ? ""
                : key === "experiments"
                ? "2"
                : key === "research"
                ? "3"
                : key === "facility"
                ? "4"
                : "5"
            }`
          );
        });
      });

      // Закрытие модальных окон
      document.querySelectorAll(".close-modal").forEach((button) => {
        button.addEventListener("click", function () {
          this.closest(".modal").style.display = "none";
        });
      });

      // Закрытие при клике вне модального окна
      window.addEventListener("click", function (e) {
        if (e.target.classList.contains("modal")) {
          e.target.style.display = "none";
        }
      });

      // Визуализация ДНК для модальных окон
      function createDNAVisualization(containerId) {
        const container = document.getElementById(containerId);
        container.innerHTML = "";

        const nodes = 15;
        const centerX = container.offsetWidth / 2;
        const centerY = container.offsetHeight / 2;
        const radius =
          Math.min(container.offsetWidth, container.offsetHeight) * 0.4;
        const angleStep = (Math.PI * 2) / nodes;

        // Создаем узлы ДНК
        for (let i = 0; i < nodes; i++) {
          const angle = i * angleStep;
          const x = centerX + Math.cos(angle) * radius;
          const y = centerY + Math.sin(angle) * (radius * 0.3);

          const node = document.createElement("div");
          node.className = "dna-node";
          node.style.left = `${x}px`;
          node.style.top = `${y}px`;
          node.style.animationDelay = `${i * 0.1}s`;
          container.appendChild(node);

          // Создаем соединения между узлами
          if (i > 0) {
            const prevAngle = (i - 1) * angleStep;
            const prevX = centerX + Math.cos(prevAngle) * radius;
            const prevY = centerY + Math.sin(prevAngle) * (radius * 0.3);

            const length = Math.sqrt(
              Math.pow(x - prevX, 2) + Math.pow(y - prevY, 2)
            );
            const connAngle =
              Math.atan2(y - prevY, x - prevX) * (180 / Math.PI);

            const connection = document.createElement("div");
            connection.className = "dna-connection";
            connection.style.width = `${length}px`;
            connection.style.left = `${prevX}px`;
            connection.style.top = `${prevY}px`;
            connection.style.transform = `rotate(${connAngle}deg)`;
            connection.style.animationDelay = `${i * 0.1}s`;
            container.appendChild(connection);
          }
        }
      }

      // Создание частиц для визуализации экспериментов
      function createParticles(containerId) {
        const container = document.getElementById(containerId);
        container.innerHTML = "";

        const particleCount = 30;

        for (let i = 0; i < particleCount; i++) {
          const particle = document.createElement("div");
          particle.className = "particle";
          particle.style.left = `${Math.random() * 100}%`;
          particle.style.top = `${Math.random() * 100}%`;
          particle.style.width = `${Math.random() * 6 + 2}px`;
          particle.style.height = particle.style.width;
          particle.style.animationDelay = `${Math.random() * 5}s`;
          particle.style.animationDuration = `${Math.random() * 3 + 2}s`;

          // Разные цвета частиц
          const colors = [
            "#8e44ad",
            "#2ecc71",
            "#f39c12",
            "#e74c3c",
            "#3498db",
          ];
          particle.style.backgroundColor =
            colors[Math.floor(Math.random() * colors.length)];

          container.appendChild(particle);

          // Анимация частиц
          animateParticle(particle);
        }
      }

      function animateParticle(particle) {
        const duration = parseFloat(particle.style.animationDuration) * 1000;

        function move() {
          particle.style.opacity = "0.8";
          particle.style.transform = `translate(${
            Math.random() * 100 - 50
          }px, ${Math.random() * 100 - 50}px)`;

          setTimeout(() => {
            particle.style.opacity = "0";
            particle.style.transform = "translate(0, 0)";

            setTimeout(() => {
              move();
            }, 500);
          }, duration);
        }

        setTimeout(move, parseFloat(particle.style.animationDelay) * 1000);
      }

      // Генерация случайных пузырьков для каждой капсулы
      document.querySelectorAll(".capsule").forEach((capsule) => {
        const bubblesContainer = capsule.querySelector(".bubbles");
        const bubbleCount = Math.floor(Math.random() * 8) + 5; // 5-12 пузырьков

        // Создаем случайные пузырьки
        for (let i = 0; i < bubbleCount; i++) {
          const size = Math.random() * 8 + 3; // 3-11px
          const left = Math.random() * 80 + 10; // 10-90%
          const delay = Math.random() * 5;
          const duration = Math.random() * 4 + 4; // 4-8s
          const opacity = Math.random() * 0.3 + 0.2; // 0.2-0.5

          const bubble = document.createElement("div");
          bubble.className = "bubble";
          bubble.style.left = `${left}%`;
          bubble.style.width = `${size}px`;
          bubble.style.height = `${size}px`;
          bubble.style.animationDelay = `${delay}s`;
          bubble.style.animationDuration = `${duration}s`;
          bubble.style.opacity = opacity;
          bubble.style.bottom = `${Math.random() * 20}px`;

          bubblesContainer.appendChild(bubble);
        }
      });

      // Консольные сообщения
      const consoleMessages = [
        "Monitoring specimen vitals...",
        "Adjusting nutrient levels in capsule H-782",
        "Security sweep in Sector 4 complete",
        "Warning: temperature fluctuation in Lab 3",
        "Data upload to central archive 87% complete",
        "Specimen H-219 requesting interaction",
        "Denied: interaction protocol violation",
        "Scheduled maintenance in 6 hours",
        "Biocapsule integrity at 98.7%",
        "Alert: unusual activity in specimen H-532",
        "Containment protocols activated",
        "Resuming normal operations",
      ];

      const consolePanel = document.querySelectorAll(".console-panel")[1];

      function addConsoleMessage() {
        const message =
          consoleMessages[Math.floor(Math.random() * consoleMessages.length)];
        const line = document.createElement("div");
        line.className = "console-line";
        line.innerHTML = `<span class="console-prompt">> </span>${message}`;

        consolePanel.appendChild(line);

        // Удаляем старые сообщения, если их слишком много
        if (consolePanel.children.length > 8) {
          consolePanel.removeChild(consolePanel.children[0]);
        }

        // Прокрутка вниз
        consolePanel.scrollTop = consolePanel.scrollHeight;

        // Следующее сообщение через случайный интервал
        setTimeout(addConsoleMessage, Math.random() * 5000 + 3000);
      }

      // Запускаем консольные сообщения
      setTimeout(addConsoleMessage, 2000);

      // Анимация при загрузке
      document.addEventListener("DOMContentLoaded", () => {
        const specimens = document.querySelectorAll(".specimen");

        specimens.forEach((specimen, index) => {
          specimen.style.opacity = "0";
          specimen.style.transform = "translateY(20px)";
          specimen.style.transition = "opacity 0.5s, transform 0.5s";

          setTimeout(() => {
            specimen.style.opacity = "1";
            specimen.style.transform = "translateY(0)";
          }, index * 150);
        });

        // Анимация сканирующей линии
        const scanLine = document.querySelector(".scan-line");
        setInterval(() => {
          scanLine.style.top = "0";
          scanLine.style.opacity = "0";
          setTimeout(() => {
            scanLine.style.transition = "none";
            scanLine.style.top = "0";
            void scanLine.offsetWidth; // Trigger reflow
            scanLine.style.transition = "top 8s linear, opacity 1s ease";
            scanLine.style.opacity = "1";
            scanLine.style.top = "100%";
          }, 50);
        }, 8000);
      });
    </script>
  

</body></html>
