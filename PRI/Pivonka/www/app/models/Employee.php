<?php
class Employee {
    public int $id;
    public int $position_id;
    public string $first_name;
    public string $last_name;
    public string $email;
    public ?string $phone;
    public string $hire_date;

    public function __construct(array $data) {
        $this->id = $data['id'] ?? 0;
        $this->position_id = $data['position_id'];
        $this->first_name = $data['first_name'];
        $this->last_name = $data['last_name'];
        $this->email = $data['email'];
        $this->phone = $data['phone'] ?? null;
        $this->hire_date = $data['hire_date'];
    }

    public function toArray(): array {
        return [
            'id' => $this->id,
            'position_id' => $this->position_id,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'email' => $this->email,
            'phone' => $this->phone,
            'hire_date' => $this->hire_date,
        ];
    }
}
