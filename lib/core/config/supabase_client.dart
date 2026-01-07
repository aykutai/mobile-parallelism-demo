import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulama genelinde kullanılacak Supabase client kısayolu.
/// Önce main() içinde Supabase.initialize çağrılmış olmalı.
final SupabaseClient supabase = Supabase.instance.client;