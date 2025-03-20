<?php
class MenuItem {
    public int $id;
    public string $name;
    public float $price;

    public function __construct(array $data) {
        $this->id = $data['id'] ?? 0;
        $this->name = $data['name'];
        $this->price = (float) $data['price'];
    }

    public function toArray(): array {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'price' => $this->price,
        ];
    }
}
