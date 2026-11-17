<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use Config\Services;

class UmkmController extends ResourceController
{
    protected $modelName = 'App\Models\UmkmModel';
    protected $format = 'json';

    private $rules = [
        'nama_umkm' => 'required|min_length[3]|max_length[100]',
        'pemilik' => 'required|max_length[100]',
        'alamat' => 'required|max_length[255]',
        'kategori' => 'required|in_list[Kuliner,Fashion,Kerajinan,Jasa,Pertanian,Lainnya]',
        'kontak' => 'required|min_length[8]|max_length[20]',
    ];

    private $messages = [
        'nama_umkm' => [
            'required' => 'Nama UMKM wajib diisi',
            'min_length' => 'Nama UMKM minimal 3 karakter',
        ],
        'pemilik' => ['required' => 'Pemilik wajib diisi'],
        'alamat' => ['required' => 'Alamat wajib diisi'],
        'kategori' => [
            'required' => 'Kategori wajib diisi',
            'in_list' => 'Kategori tidak valid',
        ],
        'kontak' => [
            'required' => 'Kontak wajib diisi',
            'min_length' => 'Kontak minimal 8 digit',
        ],
    ];

    private function ambilData()
    {
        $data = json_decode($this->request->getBody() ?? '', true);
        if (is_array($data)) {
            return $data;
        }
        return $this->request->getPost();
    }

    private function cekValidasi($data)
    {
        $validation = Services::validation();
        $validation->setRules($this->rules, $this->messages);
        if ($validation->run($data)) {
            return null;
        }
        return $validation->getErrors();
    }

    private function gagal($message, $code, $errors = null)
    {
        $body = ['success' => false, 'message' => $message];
        if ($errors !== null) {
            $body['errors'] = $errors;
        }
        return $this->respond($body, $code);
    }

    public function index()
    {
        $q = $this->request->getGet('q');
        if ($q) {
            $this->model->like('nama_umkm', $q);
        }
        $data = $this->model->orderBy('id', 'DESC')->findAll();

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data' => $data,
        ], 200);
    }

    public function show($id = null)
    {
        $data = $this->model->find($id);
        if (!$data) {
            return $this->gagal('Data UMKM tidak ditemukan', 404);
        }

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diambil',
            'data' => $data,
        ], 200);
    }

    public function create()
    {
        $input = $this->ambilData();
        $errors = $this->cekValidasi($input);
        if ($errors) {
            return $this->gagal('Gagal menambahkan data UMKM', 400, $errors);
        }

        $id = $this->model->insert($input);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil ditambahkan',
            'data' => $this->model->find($id),
        ], 201);
    }

    public function update($id = null)
    {
        if (!$this->model->find($id)) {
            return $this->gagal('Data UMKM tidak ditemukan', 404);
        }

        $input = $this->ambilData();
        $errors = $this->cekValidasi($input);
        if ($errors) {
            return $this->gagal('Gagal memperbarui data UMKM', 400, $errors);
        }

        $this->model->update($id, $input);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil diperbarui',
            'data' => $this->model->find($id),
        ], 200);
    }

    public function delete($id = null)
    {
        $data = $this->model->find($id);
        if (!$data) {
            return $this->gagal('Data UMKM tidak ditemukan', 404);
        }

        $this->model->delete($id);

        return $this->respond([
            'success' => true,
            'message' => 'Data UMKM berhasil dihapus',
            'data' => [
                'id' => $data['id'],
                'nama_umkm' => $data['nama_umkm'],
            ],
        ], 200);
    }
}