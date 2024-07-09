<?php

use function Pest\Laravel\get;

test('should return status code 200', function () {

    get('/')->assertStatus(200);
});
