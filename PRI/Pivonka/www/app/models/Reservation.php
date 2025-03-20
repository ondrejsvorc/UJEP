<?php
class Reservation {
    public int $id;
    public int $customer_id;
    public int $table_id;
    public string $date;
    public string $time_from;
    public string $time_to;

    public function __construct(array $data) {
        $this->id = $data['id'] ?? 0;
        $this->customer_id = $data['customer_id'];
        $this->table_id = $data['table_id'];
        $this->date = $data['date'];
        $this->time_from = $data['time_from'];
        $this->time_to = $data['time_to'];
    }

    public function toArray(): array {
        return [
            'id' => $this->id,
            'customer_id' => $this->customer_id,
            'table_id' => $this->table_id,
            'date' => $this->date,
            'time_from' => $this->time_from,
            'time_to' => $this->time_to,
        ];
    }
}
