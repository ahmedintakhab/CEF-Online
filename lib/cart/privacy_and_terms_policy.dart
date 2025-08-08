import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyAndTermsPolicyScreen extends StatelessWidget {
  const PrivacyAndTermsPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Privacy Policy',style: TextStyle(color: Color(0xFF78A03F),
            fontWeight: FontWeight.bold,fontSize: 24.sp),),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: Text(
                // 'Privacy Policy\nEffective Date: 1st Jan 2025',
                'Effective Date: 1st Jan 2025',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             SizedBox(height: 16.h),
             Text(
              'CEF Online ("we," "us," or "our") is committed to protecting the privacy and security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and protect your data when you access our platform or use our services.\n\n'
                  'By using CEF Online, you agree to the terms outlined in this Privacy Policy. If you do not agree, please refrain from using our platform.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '1. Information We Collect',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              '1.1 Information You Provide Directly',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'Personal Data: Name, email address, phone number, and other details provided during account registration or course enrollment.\n'
                  'Payment Information: Payment details provided for purchasing courses or materials (processed securely by third-party payment processors).\n'
                  'Course Activity: Information about your progress and interaction with the courses.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '1.2 Information Collected Automatically',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'Device Information: IP address, browser type, operating system, and device type.\n'
                  'Usage Data: Pages viewed, time spent on the platform, and actions performed.\n'
                  'Cookies: Data collected via cookies to enhance your browsing experience.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '1.3 Information from Third Parties',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'We may receive data from third-party services like payment gateways or analytics providers.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '2. How We Use Your Information',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'To provide, operate, and improve our platform and services.\n'
                  'To personalize your experience and deliver content tailored to your preferences.\n'
                  'To process payments and manage your account.\n'
                  'To send important updates, notifications, and promotional materials (with your consent).\n'
                  'To comply with legal obligations and enforce our terms of service.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '3. How We Share Your Information',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              '3.1 Service Providers',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'With trusted third-party vendors (e.g., payment processors, hosting providers) to facilitate our services.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '3.2 Legal Requirements',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'When required by law or in response to valid legal requests by public authorities.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '3.3 Business Transfers',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'In the event of a merger, acquisition, or sale of assets, your information may be transferred to the new entity.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '4. How We Protect Your Information',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'We employ industry-standard security measures to protect your data, including encryption, firewalls, and secure servers. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '5. Your Rights and Choices',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'Access and Portability: Request access to the data we hold about you.\n'
                  'Correction: Update or correct your information.\n'
                  'Deletion: Request deletion of your personal data (subject to legal and contractual obligations).\n'
                  'Opt-Out: Unsubscribe from promotional communications at any time.\n'
                  'To exercise these rights, please contact us using the details below.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '6. Data Retention',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'We retain your personal information for as long as necessary to fulfill the purposes outlined in this policy, comply with legal obligations, and resolve disputes.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '7. Third-Party Links',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'Our platform may contain links to third-party websites or services. We are not responsible for their privacy practices, and we encourage you to review their policies independently.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
            Text(
              '8. Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'We may update this Privacy Policy from time to time to reflect changes in our practices or applicable laws. Updates will be posted on this page with an updated effective date.\n',
              style: TextStyle(fontSize: 18.sp),
            ),
             Text(
              '9. Contact Us',
              style: TextStyle(
                fontSize: 20.sp,

                fontWeight: FontWeight.bold,
                color: Color(0xFF78A03F),
              ),
            ),
             Text(
              'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us:\n\n'
                  'Email: [Your email address]\n'
                  'Phone: [Your phone number]\n',
              style: TextStyle(fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }
}