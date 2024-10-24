package com.example.demo.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.MongoException;
import com.mongodb.ServerApi;
import com.mongodb.ServerApiVersion;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.convert.MongoCustomConversions;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Arrays;
import java.util.Date;

public class MongoConfig {

    @Bean
    public MongoCustomConversions mongoCustomConversions() {
        return new MongoCustomConversions(Arrays.asList(
                // Convert LocalDateTime to Date
                new org.springframework.core.convert.converter.Converter<LocalDateTime, Date>() {
                    @Override
                    public Date convert(LocalDateTime source) {
                        return Date.from(source.toInstant(ZoneOffset.UTC));
                    }
                },
                // Convert Date to LocalDateTime
                new org.springframework.core.convert.converter.Converter<Date, LocalDateTime>() {
                    @Override
                    public LocalDateTime convert(Date source) {
                        return LocalDateTime.ofInstant(source.toInstant(), ZoneOffset.UTC);
                    }
                }
        ));
    }

    @Bean
    public MongoTemplate mongoTemplate() {
        // Use the connection string with ssl=false
        return new MongoTemplate(MongoClients.create("mongodb://mongo:mJIRiQbGZLiCfarZPGlsQqMqRqmcAzdp@junction.proxy.rlwy.net:34717/Users?authSource=admin&retryWrites=true&ssl=false"),
                "Users");
    }

    public static void main(String[] args) {
        // Connection string with ssl=false
        String connectionString = "mongodb://mongo:mJIRiQbGZLiCfarZPGlsQqMqRqmcAzdp@junction.proxy.rlwy.net:34717/Users?authSource=admin&retryWrites=true&ssl=false";

        ServerApi serverApi = ServerApi.builder()
                .version(ServerApiVersion.V1)
                .build();

        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(new ConnectionString(connectionString))
                .serverApi(serverApi)
                .build();

        // Create a new client and connect to the server
        try (MongoClient mongoClient = MongoClients.create(settings)) {
            try {
                // Send a ping to confirm a successful connection
                MongoDatabase database = mongoClient.getDatabase("admin");
                database.runCommand(new Document("ping", 1));
                System.out.println("Pinged your deployment. You successfully connected to MongoDB!");
            } catch (MongoException e) {
                e.printStackTrace();
            }
        }
    }
}
