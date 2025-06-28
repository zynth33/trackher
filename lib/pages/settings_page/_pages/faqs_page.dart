import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../_components/help_button.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Help Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "Search for help...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      HelpButton(icon: Icons.chat_bubble_outline, label: "Live Chat", color: Colors.blue),
                      HelpButton(icon: Icons.email_outlined, label: "Email Us", color: Colors.green),
                      HelpButton(icon: Icons.call_outlined, label: "Call", color: Colors.purple),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Frequently Asked Questions", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )),
                  const SizedBox(height: 12),
                  ...AppConstants.faqs.map((faq) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          faq.question,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.help_outline_rounded, color: Colors.grey),
                        onExpansionChanged: (expanded) {},
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)), // rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                              child: Text(faq.answer),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Still Need Help?", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )),
                  SizedBox(height: 15,),
                  Text("📧 Email: support@trackher.com", style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),),
                  SizedBox(height: 8,),
                  Text("📞 Phone: +1 (555) 123-HELP", style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),),
                  SizedBox(height: 8,),
                  Text("🕒 Hours: Mon-Fri 9AM-6PM EST", style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


