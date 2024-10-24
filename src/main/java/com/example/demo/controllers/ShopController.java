package com.example.demo.controllers;

import com.example.demo.models.Wallet;
import com.example.demo.services.WalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class ShopController {

    @Autowired
    private WalletService walletService;

    // Возвращаем страницу магазина
    @GetMapping("/shop")
    public String showShopPage() {
        return "shop"; // Вернуть страницу shop.html
    }

    // Обработка POST-запроса для сохранения адреса кошелька
    @PostMapping("/save-wallet")
    public String saveWallet(@RequestParam String walletAddress) {
        // Сохранение кошелька через сервис
        Wallet wallet = new Wallet();
        wallet.setAddress(walletAddress);
        walletService.save(wallet);
        return "Кошелек сохранен!";
    }
}
