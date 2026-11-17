<?php

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

class UmkmSeeder extends Seeder
{
    public function run()
    {
        $now = date('Y-m-d H:i:s');

        $this->db->table('umkm')->insertBatch([
            [
                'nama_umkm' => 'Kopi Nusantara',
                'pemilik' => 'Rafi A',
                'alamat' => 'Jl. Ayani No. 10, Banjarbaru',
                'kategori' => 'Kuliner',
                'kontak' => '08123456789',
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'nama_umkm' => 'Batik Banjar',
                'pemilik' => 'Siti Aminah',
                'alamat' => 'Jl. Sasirangan No. 5, Banjarmasin',
                'kategori' => 'Fashion',
                'kontak' => '08129876543',
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'nama_umkm' => 'Anyaman Rotan',
                'pemilik' => 'Budi Santoso',
                'alamat' => 'Jl. Lambung Mangkurat No. 21, Banjarmasin',
                'kategori' => 'Kerajinan',
                'kontak' => '08135551234',
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);
    }
}
