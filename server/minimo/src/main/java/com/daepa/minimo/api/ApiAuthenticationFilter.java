package com.daepa.minimo.api;

import com.daepa.minimo.common.enums.AccountRole;
import com.daepa.minimo.dto.UserDto;
import com.daepa.minimo.exception.ApiUnauthenticatedException;
import com.daepa.minimo.repository.UserRepository;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@RequiredArgsConstructor
@Slf4j
public class ApiAuthenticationFilter extends OncePerRequestFilter {
    private final UserRepository userRepository;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        log.info("request url: {}", request.getRequestURL());

        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String jwtToken = authHeader.substring(7);

            try {
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(jwtToken);
                String email = decodedToken.getEmail();
                log.info("Successfully firebase token verified: {}", email);

                AccountRole accountRole = userRepository.getAccountRoleByUserEmail(email);
                if (accountRole != null) {
                    SecurityContextHolder.getContext().setAuthentication(
                            new UsernamePasswordAuthenticationToken(email, null, Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + accountRole.name())))
                    );
                } else {
                    SecurityContextHolder.getContext().setAuthentication(
                            new UsernamePasswordAuthenticationToken(email, null, Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + AccountRole.USER)))
                    );
                }

            } catch (FirebaseAuthException e) {
                log.error("ApiAuthorizationFilter doFilterInternal FirebaseAuthException: {}", e.getMessage());
                throw new ApiUnauthenticatedException();
            }

        } else {
            throw new ApiUnauthenticatedException();
        }

        filterChain.doFilter(request, response);
    }
}
