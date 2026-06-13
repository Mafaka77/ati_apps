import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:training_apps/reusables/colors.dart';

class TermsScreen extends StatelessWidget {
  TermsScreen({super.key});

  // Reactive string to control current active documentation layout tab
  final RxString activeTab = 'privacy'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.home_background,
      appBar: AppBar(
        backgroundColor: MyColors.home_background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Legal Information",
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'SN Pro',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTabSelector(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Obx(
                    () => SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      child: activeTab.value == 'privacy'
                          ? _buildPrivacyPolicyContent()
                          : _buildTermsAndConditionsContent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                final bool isSelected = activeTab.value == 'privacy';
                return GestureDetector(
                  onTap: () => activeTab.value = 'privacy',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF6B7280),
                          fontFamily: 'SN Pro',
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                final bool isSelected = activeTab.value == 'terms';
                return GestureDetector(
                  onTap: () => activeTab.value = 'terms',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF6B7280),
                          fontFamily: 'SN Pro',
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaHeader("Effective Date: May 26, 2026"),
        _buildSectionHeading("1. Introduction & Core Mandate"),
        _buildBodyText(
          "The Administrative Training Institute (ATI), Government of Mizoram (\"we\", \"us\", \"our\"), values your privacy. This Privacy Policy governs the data collection, processing, and storage practices for the ATIMZ Mobile Application (the \"App\"). The App serves as an official mobile portal for government personnel to monitor enrollment requests, access training calendars, review personal training histories, and view official directives.",
        ),
        _buildBodyText(
          "By downloading, installing, or interacting with the App, you explicitly consent to the data architecture detailed in this policy.",
        ),

        _buildSectionHeading("2. Information We Collect"),
        _buildBodyText(
          "To deliver secure mobile synchronization, the App processes the following data categories:",
        ),
        _buildBulletPoint(
          "User Profile & Professional Data: Legal full name, official mobile number, government email address, parent department/directorate, and current designation.",
        ),
        _buildBulletPoint(
          "Mobile Device Identifiers: Hardware model, operating system version (iOS/Android), unique device identifiers (UUID), and device push notification tokens required for real-time training alerts.",
        ),
        _buildBulletPoint(
          "Transactional Training Logs: Course selection logs, attendance tracking indexes, course assessment results, and application statuses (Pending, Approved, Rejected, Waitlisted).",
        ),
        _buildBulletPoint(
          "Application Log Files: Performance tracking metrics, system crash logs, and cryptographic access tokens generated during session authentications.",
        ),

        _buildSectionHeading("3. Explicit Permissions Required"),
        _buildBodyText(
          "The App will request the following native mobile operating system permissions:",
        ),
        _buildBulletPoint(
          "Notifications Permission: Required to push critical real-time alerts regarding training selections, waitlist changes, and official orders.",
        ),
        _buildBulletPoint(
          "Storage Access (Read/Write): Required to download, cache, and open official signed document PDFs (such as Release Orders and Completion Certificates) directly on your mobile device.",
        ),

        _buildSectionHeading("4. Purposes of Processing Data"),
        _buildBodyText(
          "Your information is handled strictly for internal state administration and is never monetized or distributed to unauthorized third parties. Processing is restricted to:",
        ),
        _buildBulletPoint(
          "Authenticating user profiles against centralized government training employee records.",
        ),
        _buildBulletPoint(
          "Pushing instant notifications regarding departmental nominations and deadline actions.",
        ),
        _buildBulletPoint(
          "Enabling seamless mobile rendering of generated training schedules and administrative annexures.",
        ),
        _buildBulletPoint(
          "Auditing system interactions to prevent privilege escalations and preserve platform security.",
        ),

        _buildSectionHeading("5. Data Sharing & Third-Party Interfaces"),
        _buildBodyText(
          "Data containment is stringently maintained within state-managed networks. Information is only exposed to:",
        ),
        _buildBulletPoint(
          "Controlling Authorities: Department Heads and Nodal Officers within the Government of Mizoram to coordinate employee release procedures.",
        ),
        _buildBulletPoint(
          "Statutory Compliance Channels: Law enforcement or regulatory bodies if strictly mandated by valid legal warrants or court directives under Indian law.",
        ),

        _buildSectionHeading("6. Information Security and Encryption"),
        _buildBodyText(
          "We maintain strict technical defenses to safeguard mobile endpoints:",
        ),
        _buildBulletPoint(
          "All data transit between the mobile application and backend services is enforced over secure HTTPS/TLS 1.3 channels.",
        ),
        _buildBulletPoint(
          "Sensitive device tokens and local session tokens are stored using native secure storage mechanisms (Keystore on Android, Keychain on iOS).",
        ),
        _buildBulletPoint(
          "Access controls are enforced using Role-Based Access Control (RBAC) to ensure trainees cannot access administrative system actions.",
        ),

        _buildSectionHeading("7. Your Data Rights & Redressal"),
        _buildBodyText(
          "Under prevailing digital data acts, you have the right to review your structural profile attributes. If profile records (such as parent department or designation) require correction, updates must be routed through your departmental nodal administrative desk. For privacy inquiries, contact the System Administrator at the Administrative Training Institute, Aizawl, Mizoram.",
        ),
      ],
    );
  }

  Widget _buildTermsAndConditionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetaHeader("Effective Date: May 26, 2026"),
        _buildSectionHeading("1. Acceptance of Terms"),
        _buildBodyText(
          "These Terms and Conditions constitute a valid administrative agreement between the user (\"User\", \"you\") and the Administrative Training Institute, Government of Mizoram. Downloading, registering, or maintaining a session inside the ATIMZ Mobile Application signifies absolute agreement to these provisions. If you do not agree, you must immediately uninstall the App.",
        ),

        _buildSectionHeading("2. Account Integrity and Mobile Security"),
        _buildBulletPoint(
          "Identity Mapping: Accounts are mapped to verified official credentials. You must provide completely accurate data during profile synchronization.",
        ),
        _buildBulletPoint(
          "Session Safeguards: You are solely responsible for securing your mobile device. Any activity originating from your mobile session is legally attributed to you.",
        ),
        _buildBulletPoint(
          "Unauthorized Use: You must instantly report any compromised credentials or lost mobile devices running authenticated administrative profiles to the ATI administration.",
        ),

        _buildSectionHeading("3. Rules of Use and Mobile Conduct"),
        _buildBodyText(
          "Users are strictly prohibited from performing the following actions:",
        ),
        _buildBulletPoint(
          "Utilizing the App for personal, commercial, or non-official government communications.",
        ),
        _buildBulletPoint(
          "Attempting to decompile, reverse-engineer, modify, or extract the source code of the mobile package binary.",
        ),
        _buildBulletPoint(
          "Using network interceptors, emulators, or automated bot scripts to alter or spoof mobile inputs (such as attendance signatures or search attributes).",
        ),
        _buildBulletPoint(
          "Injecting data packets designed to disrupt backend API connectivity or degrade app performance for other civil servants.",
        ),

        _buildSectionHeading("4. Mobile Documents and Legal Authenticity"),
        _buildBulletPoint(
          "Document Validity: Certificates and Office Orders visible or downloaded via the App represent official records. Documents featuring cryptographic signatures applied via integrated state gateways carry full structural validity under the Information Technology Act, 2000.",
        ),
        _buildBulletPoint(
          "Tampering Violations: Altering downloaded PDF orders, removing digital signature metadata, or falsifying status printouts generated by the App constitutes forgery and is punishable under the Indian Penal Code.",
        ),

        _buildSectionHeading(
          "5. Technical Notifications & Operational Continuity",
        ),
        _buildBulletPoint(
          "Alert Dependency: While the App transmits push alerts for your convenience, official training directives are governed by published state gazettes and orders. ATI is not responsible for missed deadlines resulting from carrier network failures, device battery optimizations, or disabled push settings.",
        ),
        _buildBulletPoint(
          "Service Suspensions: ATI Mizoram reserves the right to suspend API endpoints, restrict mobile versions, or enforce mandatory app store updates to perform planned platform upgrades or patch urgent system vulnerabilities.",
        ),

        _buildSectionHeading("6. Indemnification & Liability Ceilings"),
        _buildBulletPoint(
          "As-Is Provision: The App is delivered on an \"as-is\" framework. ATI Mizoram makes no warranties that mobile views will display perfectly across all custom aftermarket mobile operating system variations.",
        ),
        _buildBulletPoint(
          "Liability Waiver: The Government of Mizoram shall not be held liable for any data charges, device malfunctions, or administrative delays arising from your usage of the App or network instability.",
        ),

        _buildSectionHeading("7. Jurisdiction & Statutory Law"),
        _buildBodyText(
          "These Terms are governed explicitly by the laws of India and the administrative regulations of the State of Mizoram. Any legal proceedings, disputes, or structural challenges arising from the deployment of this mobile utility shall fall exclusively under the judicial authority of the competent courts in Aizawl, Mizoram.",
        ),
      ],
    );
  }

  // Atomized reusable layout micro-widgets
  Widget _buildMetaHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Color(0xFF9CA3AF),
          letterSpacing: 1.0,
          fontFamily: 'SN Pro',
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Color(0xFF111827),
          fontFamily: 'SN Pro',
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          height: 1.6,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 5, color: Color(0xFF9CA3AF)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
