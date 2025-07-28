import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prince Kumar | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE53935),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).copyWith(
          headlineLarge: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            shadows: [
              const Shadow(blurRadius: 30, color: Color(0xFFE53935)),
              const Shadow(blurRadius: 50, color: Color(0xFF1565C0)),
            ],
          ),
          headlineMedium: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            shadows: [
              const Shadow(blurRadius: 15, color: Color(0xFFE53935)),
              const Shadow(blurRadius: 25, color: Color(0xFF1565C0)),
            ],
          ),
          headlineSmall: GoogleFonts.orbitron(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
            color: Colors.white70,
          ),
          titleLarge: GoogleFonts.orbitron(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: const Color(0xFFE53935),
          ),
          bodyLarge: GoogleFonts.openSans(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: Colors.white70,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.openSans(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: Colors.white54,
            height: 1.4,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE53935),
          secondary: Color(0xFF1565C0),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();

  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 400) {
        if (!_showScrollToTopButton) {
          setState(() => _showScrollToTopButton = true);
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() => _showScrollToTopButton = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          
          CircularParticle(
            key: UniqueKey(),
            awayRadius: 80,
            numberOfParticles: 150,
            speedOfParticles: 1,
            height: screenSize.height,
            width: screenSize.width,
            onTapAnimation: true,
            particleColor: Colors.white.withAlpha(50),
            awayAnimationDuration: const Duration(milliseconds: 600),
            maxParticleSize: 4,
            isRandSize: true,
            isRandomColor: false,
            awayAnimationCurve: Curves.easeInOutBack,
            enableHover: true,
            hoverColor: Colors.white,
            hoverRadius: 90,
            connectDots: true,
          ),
          
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildHeroSection(),
              _buildSection("Technical Skills", _buildSkillsSection()),
              _buildSection("Experience", _buildExperienceSection()),
              _buildSection("Projects", _buildProjectsSection()),
              _buildSection("Education", _buildEducationSection()),
              _buildSection("Certifications", _buildCertificationsSection()),
              _buildFooter(),
            ],
          ),
          // The 3D spider that follows the scroll position.
          _buildSpiderFollower(screenSize),
        ],
      ),
    );
  }

  // A 3D spider model that "crawls" along the side of the page as the user scrolls.
  // This is the core "gamified" element.
  Widget _buildSpiderFollower(Size screenSize) {
    const spiderSize = 120.0;
    // The AnimatedBuilder will now rebuild the ModelViewer whenever the scroll position changes.
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {

        if (!_scrollController.hasClients || !_scrollController.position.hasContentDimensions) {
          return const SizedBox.shrink();
        }

        final scrollPercentage = (_scrollController.offset / _scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
        final topPosition = (screenSize.height - spiderSize * 1.5) * (1 - scrollPercentage);
        final horizontalOffset = math.sin(scrollPercentage * math.pi * 4) * 10;

        return Positioned(
          top: topPosition,
          left: 10 + horizontalOffset,
          width: spiderSize,
          height: spiderSize,
          // Using ModelViewer to display an animated 3D spider.
          // This is a huge upgrade from the FontAwesome icon.
          child: ModelViewer(
            key: const ValueKey('spider-model'),
            src: 'assets/models/spider.glb', // IMPORTANT: Add your 3D model here
            alt: 'A 3D model of a spider',
            ar: false,
            autoRotate: false,
            cameraControls: false,
            backgroundColor: Colors.transparent,
            // Conditionally change the animation based on scroll activity.
            animationName: scrollPercentage > 0.01 && scrollPercentage < 0.99 ? 'Walking' : 'Idle',
          ),
        );
      },
    );
  }

  // Each section is wrapped in a SliverToBoxAdapter and a ParallaxContainer
  // to create the pseudo-3D scrolling effect.
  Widget _buildSection(String title, Widget content) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 800 ? 48.0 : 24.0;

    return SliverToBoxAdapter(
      child: ParallaxContainer(
        scrollController: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.2),
              const SizedBox(height: 32),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: ParallaxContainer(
          scrollController: _scrollController,
          parallaxFactor: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gamified intro text with a "swinging" animation.
              Text(
                "Prince Kumar",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        const Shadow(blurRadius: 20, color: Color(0xFFE53935)),
                        const Shadow(blurRadius: 40, color: Color(0xFF1565C0)),
                      ],
                    ),
              ).animate().fadeIn(delay: 300.ms, duration: 900.ms).slideY(begin: -0.5, curve: Curves.easeOutBack),
              const SizedBox(height: 16),
              Text(
                "Flutter Developer | Backend Enthusiast | Tech Innovator",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
              ).animate().fadeIn(delay: 500.ms, duration: 900.ms).slideY(begin: 1),
              const SizedBox(height: 32),
              _buildSocialLinks(),
              const SizedBox(height: 64),
              // A visual cue to encourage scrolling.
              const FaIcon(FontAwesomeIcons.chevronDown, color: Colors.white54)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, color: const Color(0xFFE53935))
                  .then(delay: 1000.ms)
                  .shimmer(duration: 2000.ms, color: const Color(0xFF1565C0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIcon(icon: FontAwesomeIcons.envelope, url: 'mailto:prince197060@gmail.com', delay: 700.ms),
        const SizedBox(width: 24),
        _SocialIcon(icon: FontAwesomeIcons.linkedin, url: 'https://www.linkedin.com/in/prince-kumar-558142250/', delay: 800.ms),
        const SizedBox(width: 24),
        _SocialIcon(icon: FontAwesomeIcons.github, url: 'https://github.com/princekumar2024', delay: 900.ms),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = {
      "Programming Languages": ["Java", "Dart", "SQL"],
      "Frameworks & Technologies": ["Flutter", "Spring Boot"],
      "Core Competencies": ["Data Structures and Algorithms", "Mobile App Development", "Backend Development"],
      "Tools & Platforms": ["Firebase", "Git", "Android Studio", "VS Code"],
    };

    return Wrap(
      spacing: 40,
      runSpacing: 40,
      children: skills.entries.map((entry) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: entry.value.map((skill) => _SkillChip(skill: skill)).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1);
  }

  Widget _buildExperienceSection() {
    return _InfoCard(
      title: "Flutter Developer Intern",
      subtitle: "Krayde Software | Remote | 2025",
      details: const [
        "Developed mobile applications using Flutter framework with focus on cross-platform compatibility.",
        "Implemented UI/UX designs following Material Design principles.",
        "Collaborated with development team on various mobile app projects.",
        "Gained hands-on experience in mobile development lifecycle and best practices.",
      ],
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      children: [
        _InfoCard(
          title: "Cryptos Insight",
          subtitle: "Flutter, Firebase, API Integration | 2025",
          details: const [
            "Developed a comprehensive cryptocurrency tracking application with real-time data.",
            "Implemented UI for main screens including Search, Top Cryptocurrencies, News, and Detail screens.",
            "Integrated API services for fetching cryptocurrency data, news, and similar coins.",
            "Built AI-powered features for insights and cryptocurrency comparisons.",
            "Designed drawer navigation and seamless routing between screens.",
            "Implemented Firebase authentication flow for secure user access.",
          ],
          action: _ActionButton(text: "Live Demo", url: "https://cryptos-insight.web.app/"),
        ),
        const SizedBox(height: 32),
        _InfoCard(
          title: "Chess Game",
          subtitle: "Flutter, Dart, AI Algorithm | 2024",
          details: const [
            "Built a fully functional chess game with dark-themed UI using Material Design.",
            "Implemented complete chess game logic including board initialization and piece movement validation.",
            "Developed special moves functionality such as castling and pawn promotion.",
            "Created AI opponent using minimax algorithm with alpha-beta pruning for strategic gameplay.",
            "Implemented game state management including check detection and game over conditions.",
          ],
          action: _ActionButton(text: "GitHub", url: "https://github.com/princekumar2024/Chess-Game"),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return _InfoCard(
      title: "Bachelor of Technology in Information Technology",
      subtitle: "Panjab University, Chandigarh, India | 2022 – 2026",
      details: const ["Swami Sarwanand Giri Regional Center"],
    );
  }

  Widget _buildCertificationsSection() {
    return Column(
      children: [
        _InfoCard(
          title: "Flutter Development Internship Completion Certificate",
          subtitle: "Krayde Software | 2025",
          action: _ActionButton(text: "View Certificate", url: "https://www.linkedin.com/posts/prince-kumar-558142250_krayde-flutterdevelopment-internshipcompletion-activity-7193291253457539072-a_2F?utm_source=share&utm_medium=member_desktop"),
        ),
        const SizedBox(height: 32),
        _InfoCard(
          title: "Investors Summit 2025 Participation Certificate",
          subtitle: "Panjab University, Chandigarh | March 2025",
          details: const [
            "Certificate for pitching Cryptos Insight project before investors & incubators at Technology Enabling Centre, Department of Science and Technology, GoI."
          ],
          action: _ActionButton(text: "View Achievement Post", url: "https://www.linkedin.com/posts/prince-kumar-558142250_investorssummit-cryptocurrency-innovation-activity-7176589339396780032-46aK?utm_source=share&utm_medium=member_desktop"),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Center(
          child: Text(
            "Built with Flutter & ❤️ by Prince Kumar",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ).animate().fadeIn(duration: 1000.ms),
        ),
      ),
    );
  }
}

// A container that moves its child based on scroll offset to create a parallax effect.
// This is a core part of the "3D" feel without using a 3D engine.
class ParallaxContainer extends StatelessWidget {
  const ParallaxContainer({
    super.key,
    required this.child,
    required this.scrollController,
    this.parallaxFactor = 0.2,
  });

  final Widget child;
  final ScrollController scrollController;
  final double parallaxFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients ? scrollController.offset : 0.0;
        return Transform.translate(
          offset: Offset(0, -offset * parallaxFactor),
          child: child,
        );
      },
      child: child,
    );
  }
}


class WebPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) / 2;

    // Draw radial lines
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi;
      final endPoint = Offset(
        center.dx + maxRadius * math.cos(angle),
        center.dy + maxRadius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, paint);
    }

    // Draw concentric web lines
    for (int i = 1; i <= 5; i++) {
      final radius = (maxRadius / 5) * i;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    this.details = const [],
    this.action,
  });

  final String title;
  final String subtitle;
  final List<String> details;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      color: const Color(0xFF1A1A1A).withOpacity(0.85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WebPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          const Shadow(
                            color: Color(0xFFE53935),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                          const Shadow(
                            color: Color(0xFF1565C0),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, thickness: 1.2),
                  const SizedBox(height: 20),
                  ...details.map((detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FaIcon(FontAwesomeIcons.spider, size: 16, color: Colors.white38),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                detail,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (action != null) ...[
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: action!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideX(begin: 0.25);
  }
}

// A styled chip for displaying skills.
class _SkillChip extends StatefulWidget {
  const _SkillChip({required this.skill});

  final String skill;

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered ? Theme.of(context).colorScheme.primary : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          widget.skill,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _isHovered ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}


class _SocialIcon extends StatefulWidget {
  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.delay,
  });

  final IconData icon;
  final String url;
  final Duration delay;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    try {
      if (!await launchUrl(uri)) {
        debugPrint('Could not launch ${widget.url}');
      }
    } catch (e) {
      debugPrint('Error launching ${widget.url}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tooltipMessage = widget.url.split(':').first.toUpperCase();
    final color = _isHovered ? Theme.of(context).colorScheme.primary : Colors.white;

    return Tooltip(
      message: tooltipMessage,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(50),
          child: FaIcon(widget.icon, size: 28, color: color)
              .animate()
              .fadeIn(delay: widget.delay, duration: 500.ms)
              .slideY(begin: 0.5)
              .then(duration: 200.ms)
              .scale(
                begin: const Offset(1, 1),
                end: _isHovered ? const Offset(1.2, 1.2) : const Offset(1, 1),
              ),
        ),
      ),
    );
  }
}


class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.text, required this.url});

  final String text;
  final String url;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _launchUrl,
      icon: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      ),
    );
  }
}
