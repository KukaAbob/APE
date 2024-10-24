package com.example.demo.services;

import com.example.demo.models.Wallet;
import com.example.demo.repositories.WalletRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class WalletService {

    @Autowired
    private WalletRepository walletRepository;

    public void save(Wallet wallet) {
        walletRepository.save(wallet);
    }
}
