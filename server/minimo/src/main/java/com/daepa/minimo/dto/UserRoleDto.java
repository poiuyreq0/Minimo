package com.daepa.minimo.dto;

import com.daepa.minimo.common.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class UserRoleDto {
    private Long id;
    private UserRole userRole;
}