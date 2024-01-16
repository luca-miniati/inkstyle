import { createClient, Supabase } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL: string = Deno.env.get('SUPABASE_URL');
const SUPABASE_ANON_KEY: string = Deno.env.get('SUPABASE_ANON_KEY');
const BATCH_SIZE: number = 10;
const MAX_SAMPLES: number = 20;
const EMBEDDING_SIZE: number = null;
const ALPHA: number = 0.3;
const BETA: number = 0.3;

Deno.serve(async (req: Request) => {
    const { user_id, ratings = {} } = await req.json();
    const rating_urls: string[] = Object.keys(ratings);

    const supabase: Supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/recommendations' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
