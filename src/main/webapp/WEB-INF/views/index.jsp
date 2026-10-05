<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere – Seamless Event Management</title>
    <!-- Use standard application CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/eventsphere.css?v=11">
    
    <style>
        /* -- LANDING SPECIFIC STYLES matching app theme -- */
        .landing-hero {
            position: relative;
            min-height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(90deg, rgba(6, 16, 33, .85) 0%, rgba(6, 16, 33, .6) 50%, rgba(6, 16, 33, .3) 100%),
                        url("${pageContext.request.contextPath}/static/images/login-event.jpg") center / cover no-repeat;
            color: #ffffff;
            padding: 0 8%;
        }

        .landing-nav {
            position: absolute;
            top: 0; left: 0; right: 0;
            padding: 30px 8%;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 10;
        }

        /* Reusing exact logo styling from login/sidebar */
        .landing-brand h1 {
            font-size: 32px;
            letter-spacing: -1px;
            color: #ffffff;
            margin-bottom: 6px;
        }
        .landing-brand h1 span {
            color: #e8a020;
        }
        .landing-brand p {
            color: #d2d9e4;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        .landing-brand p em {
            color: #e8a020;
            font-style: normal;
        }

        .landing-nav-links {
            display: flex;
            gap: 25px;
            align-items: center;
        }

        .landing-nav-links a {
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: color 0.3s ease;
        }

        .landing-nav-links a:hover {
            color: #e8a020;
        }

        .landing-nav-links .btn {
            border: 2px solid #ffffff;
            background: transparent;
            color: #ffffff;
            padding: 10px 24px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
        }

        .landing-nav-links .btn:hover {
            background: #ffffff;
            color: #1e2a4a;
        }

        .landing-nav-links .btn-primary {
            background: #e8a020;
            border-color: #e8a020;
            color: #1e2a4a;
        }
        .landing-nav-links .btn-primary:hover {
            background: transparent;
            color: #e8a020;
        }

        .landing-content {
            max-width: 600px;
            z-index: 2;
            animation: fadeUp 1s ease-out forwards;
        }

        .landing-eyebrow {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            color: #e8a020;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .landing-eyebrow span {
            width: 8px; height: 8px; border-radius: 50%; background: #e8a020;
        }

        .landing-content h2 {
            font-size: clamp(48px, 6vw, 72px);
            line-height: 1.1;
            font-weight: 700;
            letter-spacing: -2px;
            margin-bottom: 24px;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        .landing-content h2 em {
            font-family: Georgia, serif;
            font-weight: 400;
            color: #f2c36d;
        }

        .landing-content p {
            font-size: 18px;
            line-height: 1.8;
            color: #e0e5ee;
            margin-bottom: 40px;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 900px) {
            .landing-nav-links { display: none; }
            .landing-content h2 { font-size: 42px; }
        }
    </style>
</head>
<body>

    <nav class="landing-nav">
        <!-- Exact logo format as requested -->
        <div class="landing-brand">
            <h1>Event<span>Sphere</span></h1>
            <p>Every detail. <em>Every moment.</em></p>
        </div>
        
        <div class="landing-nav-links">
            <a href="${pageContext.request.contextPath}/login#about">About Us</a>
            <a href="${pageContext.request.contextPath}/login#gallery">Gallery</a>
            <a href="${pageContext.request.contextPath}/login#contact">Contact Us</a>
            <a href="${pageContext.request.contextPath}/login" class="btn">Log In</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Create Account</a>
        </div>
    </nav>

    <section class="landing-hero">
        <div class="landing-content">
            <div class="landing-eyebrow"><span></span> MADE FOR MEMORABLE MOMENTS</div>
            <h2>Great events.<br>Beautifully<br><em>orchestrated.</em></h2>
            <p>From luxurious weddings to grand corporate galas, EventSphere provides the world-class tools and network you need to orchestrate unforgettable experiences.</p>
            <div style="display:flex; gap:16px;">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding:14px 28px; font-size:16px;">Get Started</a>
                <a href="${pageContext.request.contextPath}/login#about" class="btn" style="padding:14px 28px; font-size:16px; border:2px solid #fff; color:#fff; text-decoration:none; border-radius:8px;">Learn More</a>
            </div>
        </div>
    </section>

</body>
</html>


