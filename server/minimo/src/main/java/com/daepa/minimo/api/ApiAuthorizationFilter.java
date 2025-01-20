package com.daepa.minimo.api;

import com.daepa.minimo.exception.ApiForbiddenException;
import com.daepa.minimo.exception.ApiUnauthorizedException;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Slf4j
public class ApiAuthorizationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        log.info("request url: {}", request.getRequestURL());

        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String jwtToken = authHeader.substring(7);

            try {
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(jwtToken);
                String uid = decodedToken.getUid();
                log.info("Successfully firebase token verified: {}", uid);

                SecurityContextHolder.getContext().setAuthentication(
                        new UsernamePasswordAuthenticationToken(uid, null, Collections.emptyList())
                );

            } catch (FirebaseAuthException e) {
                log.error("ApiAuthorizationFilter doFilterInternal FirebaseAuthException: {}", e.getMessage());
                throw new ApiForbiddenException();
            }

        } else {
            throw new ApiUnauthorizedException();
        }

        filterChain.doFilter(request, response);
    }
}
