import 'package:cos_challenge/data/models/suggestion_model.dart';
import 'package:flutter/material.dart';

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<SuggestionModel> suggestions;
  final void Function(SuggestionModel) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Suggestions Found',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '\nSelect one bellow to proceed',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (_, index) {
              final s = suggestions[index];
              return ListTile(
                title: Text('${s.make} ${s.model}'),
                subtitle: Text(s.containerName),
                trailing: Text('${s.similarity}%'),
                onTap: () => onTap(s),
              );
            },
          ),
        ),
      ],
    );
  }
}
