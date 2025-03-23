<?php
declare(strict_types=1);

final class OperationResult {
    public readonly bool $isSuccess;
    public readonly ?string $errorMessage;
    public readonly ?mixed $data;

    private function __construct(bool $isSuccess, ?string $errorMessage, ?mixed $data) {
        $this->isSuccess = $isSuccess;
        $this->errorMessage = $errorMessage;
        $this->data = $data;
    }

    public static function success(?mixed $data = null): self {
        return new self(true, null, $data);
    }

    public static function failure(string $errorMessage, ?mixed $data = null): self {
        return new self(false, $errorMessage, $data);
    }
}