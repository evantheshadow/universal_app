class UrbanDictionaryCardResponse {
  final List<UrbanDictionaryCard> posts;

  UrbanDictionaryCardResponse({required this.posts});

  factory UrbanDictionaryCardResponse.fromJson(Map<String, dynamic> json) {
    final jsonPosts = json['list'] as List;
    final posts = jsonPosts.map((e) => UrbanDictionaryCard.fromJson(e)).toList();
    return UrbanDictionaryCardResponse(
        posts: posts,
    );
  }
}

class UrbanDictionaryCard {
  final int? defID;
  final String? word;
  final String? author;
  final String? definition;
  // final List<SoundUrls>? soundList;
  final int? likes;
  final int? dislikes;
  final String? createdOn;
  final String? example;

  // var dateTime2 = DateFormat('d/M/y').parse(mdyString);


  UrbanDictionaryCard({
    this.defID,
    this.word,
    this.author,
    this.definition,
    this.likes,
    this.dislikes,
    this.createdOn,
    this.example,
  });

  factory UrbanDictionaryCard.fromJson(Map<String, dynamic> json) {
    return UrbanDictionaryCard(
      defID: json['defid'] as int ?? 0,
      word: json['word'] as String ?? '',
      author: json['author'] as String ?? '',
      definition: json['definition'] as String ?? '',
      likes: json["thumbs_up"] as int ?? 0,
      dislikes: json['thumbs_down'] as int ?? 0,
      createdOn: json['written_on'] as String ?? '',
      example: json['example'] as String ?? '',
    );
  }
}