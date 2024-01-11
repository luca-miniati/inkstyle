import { createClient } from '@supabase/supabase-js';
import { config } from 'dotenv';
import fs from 'fs';

config();

const supabase = createClient(
    'https://bnuakobfluardglvfltt.supabase.co',
    process.env.SUPABASE_SERVICE_ROLE
);

async function uploadFile(filePathFull, filePath) {
  const fileContent = fs.readFileSync(filePathFull);
  const { _, error } = await supabase.storage.from('images').upload(filePath, fileContent);
  if (error) {
    console.log(error.message);
  }
}

fs.readdir('images/cleaned/_', async (err, files) => {
  if (err) {
    console.log(err.message);
    return;
  }

  for (let i = 0; i < files.length; i++) {
    await uploadFile(`images/cleaned/_/${files[i]}`, `images/${files[i]}`);
    console.log(`uploaded ${files[i]}`);
  }
});
