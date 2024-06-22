package com.example;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.net.InetAddress;

@Controller
public class MyAppController {

    @GetMapping("/")
    public String index(Model model) {
        String userName = System.getProperty("user.name");
        String hostname = "unknown";
        try {
            hostname = InetAddress.getLocalHost().getHostName();
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("userName", userName);
        model.addAttribute("hostname", hostname);
        return "index";
    }
}
