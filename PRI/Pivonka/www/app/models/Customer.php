<?php
class Customer {
    public int $id;
    public string $first_name;
    public string $last_name;
    public string $email;
    public ?string $phone;

    public function __construct(array $data) {
        $this->id = $data['id'] ?? 0;
        $this->first_name = $data['first_name'];
        $this->last_name = $data['last_name'];
        $this->email = $data['email'];
        $this->phone = $data['phone'] ?? null;
    }

    public function toArray(): array {
        return [
            'id' => $this->id,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'email' => $this->email,
            'phone' => $this->phone,
        ];
    }
}
