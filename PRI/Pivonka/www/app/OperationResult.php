<?php
declare(strict_types=1);

final class OperationResult {
    public readonly bool $isSuccess;
    public readonly ?string $errorMessage;

    private function __construct(bool $isSuccess, ?string $errorMessage) {
        $this->isSuccess = $isSuccess;
        $this->errorMessage = $errorMessage;
    }

    public static function success(): self {
        return new self(true, null);
    }

    public static function failure(string $errorMessage): self {
        return new self(false, $errorMessage);
    }
}