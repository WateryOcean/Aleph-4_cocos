import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../../../core/constants/app_colors.dart';

class EventDummyData {
  static List<EventModel> events = [
    // Upcoming Events
    EventModel(
      id: 'u1',
      title: 'SAKURA HANAMI FESTIVAL 🌸 Cosplay & Coswalk Competition',
      category: 'Matsuri & Competition',
      date: '2-3 MAY 2026',
      location: 'Courtyard Pakuwon City Mall, Surabaya',
      time: '16.00 - Finish',
      imageUrl: 'assets/events_images/upcoming_1.png', 
      description: 'Pakuwon City Mall x Japan Matsuri Surabaya proudly present\n🌸 SAKURA HANAMI FESTIVAL 🌸\nCosplay & Coswalk Competition\n\nTotal Prize up to IDR 7.5 Million!\nSpecial Judges: Ryoneesan, Gerard, Unu, Andy Phebe, Piikappi, Sofya Ulfa.\nSpecial Performances: Nona Misty, VIEOS.\nMC: Jhey Azalea.',
      contactInfo: 'Dan (0812-1789-1472)',
      socialMedia: {'Instagram': '@japanmatsurisurabaya'},
      isUpcoming: true,
      accentColor: AppColors.eventAccent,
    ),
    EventModel(
      id: 'u2',
      title: 'DEPOK CHIKAFEST VOL.1',
      category: 'Idol & Fun Cosplay',
      date: '9 MAY 2026',
      location: 'Depok, West Java',
      time: 'Full Day',
      imageUrl: 'assets/events_images/upcoming_2.png',
      description: 'Hello Depok!! 🎀✨\nThe event you\'ve been waiting for is finally here! 💖\nGet ready for DEPOK CHIKAFEST VOL.1 🥳\nAn Idol + Fun Cosplay event that will make your weekend unforgettable!\n\n🔥 Featuring:\n🎤 8+ Idol Performances\n🎙️ Idol Talkshow\n🎭 Cosplay Parade\n🛍️ Bazzar Merch\n🌟 Guest Star\n🎧 DJ Performance',
      contactInfo: 'Depok Chikafest Team',
      socialMedia: {'Instagram': '@depokchikafest'},
      isUpcoming: true,
      accentColor: const Color(0xFF6C5CE7),
    ),
    
    // Completed Events
    EventModel(
      id: 'c1',
      title: 'Cosplay Community Gathering & Party',
      category: 'Tangcity x 7K',
      date: '26 JAN 2025',
      location: 'Main Atrium, GF Tangcity Mall',
      time: '19.00 - 21.00',
      imageUrl: 'assets/events_images/finished_1.png',
      description: 'Besides cosplay, there are many other exciting activities!\n✨ Cosplay Community Gathering\n✨ Idol Performance\n✨ Cosplay Parade\n✨ Sing A Long\n✨ Games, and many more!\n\nSpecial Performances:\n@soonmiracle.official\n@ind48_ofc\n@kirashi_dream\n\nMC:\n@oniliciouzz\n@i.dantewsaurus\n\nOrganizing Partner: @sevenkingdom.ofc',
      contactInfo: '7K 0897-8179-267',
      socialMedia: {'Instagram': '@sevenkingdom.ofc'},
      isUpcoming: false,
      accentColor: AppColors.eventAccent,
    ),
    EventModel(
      id: 'c2',
      title: 'SATOSHI 2025',
      category: 'Anime Festival',
      date: '20 DEC 2025',
      location: 'Raden Wijaya UB, Malang',
      time: '08:00 AM - Finish',
      imageUrl: 'assets/events_images/finished_2.png',
      description: 'WELCOME TO SATOSHI 2025\n✨Good evening, everyone✨\nThis year\'s event will be even more exciting than before.\nFeaturing Luxuria, Star Captain, Himawari, and many other amazing performances.\nDon\'t miss the beautiful Hanabi fireworks at the end of the show.\nHTM Presale: IDR 10,000, OTS: IDR 15,000.',
      contactInfo: 'Himaprodi Pendidikan Bahasa Jepang UB',
      socialMedia: {'Instagram': '@satoshi.fibub', 'Tiktok': '@satoshi.fibub'},
      isUpcoming: false,
      accentColor: const Color(0xFFFF7675),
    ),
    EventModel(
      id: 'c3',
      title: 'Sawangan Matsuri Harajuku Festival',
      category: 'Matsuri',
      date: '08 JAN 2023',
      location: 'The Park Sawangan',
      time: 'Full Day',
      imageUrl: 'assets/events_images/finished_3.png',
      description: 'Don\'t miss The Park Sawangan Matsuri Harajuku Festival. This event is enlivened with various activities such as: Cosplay and Coswalk Competition, Meet & Greet with Favorite Cosplayers, Bazaar, and Japanese Culture.',
      contactInfo: 'Tiana (0858-9445-7487) / Yunus (0813-1644-6237)',
      socialMedia: {'Instagram': '@theparksawangan'},
      isUpcoming: false,
      accentColor: const Color(0xFF6C5CE7),
    ),
  ];
}
