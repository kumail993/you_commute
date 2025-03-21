import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

late SupabaseClient supabase;

Future<void> supabaseInit() async {
  log('Hello');
  try {
    await Supabase.initialize(
      url: 'https://phggydtcvfrlcdlbtngm.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBoZ2d5ZHRjdmZybGNkbGJ0bmdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzMzk1MjAsImV4cCI6MjA1NzkxNTUyMH0._5oOwSB2M_ylwfvgCgkW5Qi9o6InhH84Q7OrdjSbtEM',
    );
    supabase = Supabase.instance.client;
    log(supabase.toString());
    log('supabase initialized');
  } catch (e) {
    log(e.toString());
  }
}
