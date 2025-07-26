/**
 * @fileoverview Security test template for Grammar Ops
 * @module security.test.template
 */

import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, beforeEach, jest } from '@jest/globals';

describe('${ComponentName} Security', () => {
  const mockUser = {
    id: 'test-user-123',
    role: 'user',
    permissions: ['read']
  };

  describe('authentication', () => {
    it('should reject unauthenticated access', () => {
      const mockOnAuthError = jest.fn();
      render(<${ComponentName} user={null} onAuthError={mockOnAuthError} />);
      
      expect(mockOnAuthError).toHaveBeenCalledWith({
        type: 'authentication',
        message: 'User not authenticated'
      });
    });

    it('should validate session before rendering', () => {
      const mockValidateSession = jest.fn().mockReturnValue(true);
      render(<${ComponentName} user={mockUser} validateSession={mockValidateSession} />);
      
      expect(mockValidateSession).toHaveBeenCalledWith(mockUser);
    });

    it('should handle expired sessions gracefully', () => {
      const expiredUser = { ...mockUser, sessionExpiry: Date.now() - 1000 };
      const mockOnSessionExpired = jest.fn();
      
      render(<${ComponentName} user={expiredUser} onSessionExpired={mockOnSessionExpired} />);
      expect(mockOnSessionExpired).toHaveBeenCalled();
    });
  });

  describe('authorization', () => {
    it('should enforce role-based access control', () => {
      const restrictedUser = { ...mockUser, role: 'guest' };
      render(<${ComponentName} user={restrictedUser} requiredRole="admin" />);
      
      expect(screen.getByText(/access denied/i)).toBeInTheDocument();
    });

    it('should check permissions before sensitive actions', () => {
      const mockAuthorizeAction = jest.fn().mockReturnValue(false);
      render(<${ComponentName} user={mockUser} authorizeAction={mockAuthorizeAction} />);
      
      const deleteButton = screen.getByRole('button', { name: /delete/i });
      fireEvent.click(deleteButton);
      
      expect(mockAuthorizeAction).toHaveBeenCalledWith(mockUser, 'delete');
      expect(screen.getByText(/insufficient permissions/i)).toBeInTheDocument();
    });

    it('should hide unauthorized UI elements', () => {
      const limitedUser = { ...mockUser, permissions: ['read'] };
      render(<${ComponentName} user={limitedUser} />);
      
      expect(screen.queryByRole('button', { name: /edit/i })).not.toBeInTheDocument();
      expect(screen.queryByRole('button', { name: /delete/i })).not.toBeInTheDocument();
    });
  });

  describe('input validation', () => {
    it('should prevent SQL injection in ${inputField}', () => {
      const maliciousInputs = [
        "'; DROP TABLE users; --",
        "1' OR '1'='1",
        "admin'--",
        "SELECT * FROM users WHERE id = '1' OR '1'='1'"
      ];

      maliciousInputs.forEach(input => {
        const mockOnValidationError = jest.fn();
        const { getByLabelText } = render(
          <${ComponentName} onValidationError={mockOnValidationError} />
        );
        
        const inputField = getByLabelText('${inputLabel}');
        fireEvent.change(inputField, { target: { value: input } });
        
        expect(mockOnValidationError).toHaveBeenCalledWith({
          field: '${inputField}',
          type: 'sql-injection',
          value: input
        });
      });
    });

    it('should prevent XSS attacks in ${displayField}', () => {
      const xssPayloads = [
        '<script>alert("XSS")</script>',
        '<img src=x onerror=alert("XSS")>',
        'javascript:alert("XSS")',
        '<iframe src="javascript:alert(\'XSS\')"></iframe>',
        '<svg/onload=alert("XSS")>'
      ];

      xssPayloads.forEach(payload => {
        const { container } = render(<${ComponentName} content={payload} />);
        
        expect(container.innerHTML).not.toContain('<script>');
        expect(container.innerHTML).not.toContain('javascript:');
        expect(container.innerHTML).not.toContain('onerror');
        expect(container.innerHTML).not.toContain('onload');
      });
    });

    it('should validate all required fields before submission', () => {
      const mockOnSubmit = jest.fn();
      render(<${ComponentName} onSubmit={mockOnSubmit} />);
      
      const submitButton = screen.getByRole('button', { name: /submit/i });
      fireEvent.click(submitButton);
      
      expect(mockOnSubmit).not.toHaveBeenCalled();
      expect(screen.getByText(/required fields missing/i)).toBeInTheDocument();
    });

    it('should sanitize file uploads', () => {
      const mockOnFileValidationError = jest.fn();
      const maliciousFile = new File(
        ['<?php system($_GET["cmd"]); ?>'],
        'shell.php',
        { type: 'application/x-php' }
      );

      render(<${ComponentName} onFileValidationError={mockOnFileValidationError} />);
      const fileInput = screen.getByLabelText(/upload file/i);
      
      fireEvent.change(fileInput, { target: { files: [maliciousFile] } });
      
      expect(mockOnFileValidationError).toHaveBeenCalledWith({
        filename: 'shell.php',
        reason: 'dangerous-file-type',
        type: 'application/x-php'
      });
    });
  });

  describe('data protection', () => {
    it('should not expose sensitive data in DOM', () => {
      const sensitiveData = {
        userId: 'user-123',
        ssn: '123-45-6789',
        creditCard: '4111-1111-1111-1111',
        apiKey: 'sk-1234567890abcdef'
      };

      const { container } = render(<${ComponentName} userData={sensitiveData} />);
      const htmlContent = container.innerHTML;
      
      expect(htmlContent).not.toContain('123-45-6789');
      expect(htmlContent).not.toContain('4111-1111-1111-1111');
      expect(htmlContent).not.toContain('sk-1234567890abcdef');
    });

    it('should mask sensitive fields in display', () => {
      render(<${ComponentName} creditCard="4111111111111111" />);
      
      const maskedCard = screen.getByText(/\*{12}1111/);
      expect(maskedCard).toBeInTheDocument();
    });

    it('should not log sensitive data', () => {
      const consoleSpy = jest.spyOn(console, 'log').mockImplementation();
      const sensitiveProps = {
        password: 'secret123',
        token: 'jwt-token-here'
      };

      render(<${ComponentName} {...sensitiveProps} debug />);
      
      const logCalls = consoleSpy.mock.calls.flat().join(' ');
      expect(logCalls).not.toContain('secret123');
      expect(logCalls).not.toContain('jwt-token-here');
      
      consoleSpy.mockRestore();
    });
  });

  describe('error handling', () => {
    it('should sanitize error messages in production', () => {
      const mockError = new Error('Database connection failed at 192.168.1.100:5432');
      const mockOnError = jest.fn();
      
      render(<${ComponentName} onError={mockOnError} environment="production" />);
      
      // Trigger an error condition
      fireEvent.click(screen.getByRole('button', { name: /trigger error/i }));
      
      expect(mockOnError).toHaveBeenCalledWith({
        message: 'An error occurred. Please try again.',
        code: 'GENERIC_ERROR'
      });
    });

    it('should not expose stack traces to users', () => {
      const error = new Error('Test error');
      error.stack = 'Error: Test error\\n    at Object.<anonymous> (/app/src/components/Secret.tsx:42:15)';
      
      render(<${ComponentName} error={error} />);
      
      expect(screen.queryByText(/Secret\.tsx/)).not.toBeInTheDocument();
      expect(screen.queryByText(/stack/i)).not.toBeInTheDocument();
    });
  });

  describe('CSRF protection', () => {
    it('should include CSRF token in state-changing requests', () => {
      const mockSubmit = jest.fn();
      const csrfToken = 'test-csrf-token';
      
      render(<${ComponentName} csrfToken={csrfToken} onSubmit={mockSubmit} />);
      
      fireEvent.click(screen.getByRole('button', { name: /save/i }));
      
      expect(mockSubmit).toHaveBeenCalledWith(
        expect.objectContaining({
          _csrf: csrfToken
        })
      );
    });

    it('should reject requests without valid CSRF token', () => {
      const mockOnSecurityError = jest.fn();
      
      render(<${ComponentName} csrfToken={null} onSecurityError={mockOnSecurityError} />);
      fireEvent.click(screen.getByRole('button', { name: /delete/i }));
      
      expect(mockOnSecurityError).toHaveBeenCalledWith({
        type: 'csrf',
        message: 'Missing CSRF token'
      });
    });
  });

  describe('rate limiting', () => {
    it('should prevent rapid repeated actions', async () => {
      const mockAction = jest.fn();
      render(<${ComponentName} onAction={mockAction} rateLimit={3} />);
      
      const actionButton = screen.getByRole('button', { name: /action/i });
      
      // Attempt 5 rapid clicks
      for (let i = 0; i < 5; i++) {
        fireEvent.click(actionButton);
      }
      
      expect(mockAction).toHaveBeenCalledTimes(3);
      expect(screen.getByText(/rate limit exceeded/i)).toBeInTheDocument();
    });
  });

  describe('audit logging', () => {
    it('should log security-relevant actions', () => {
      const mockAuditLog = jest.fn();
      render(<${ComponentName} user={mockUser} auditLog={mockAuditLog} />);
      
      fireEvent.click(screen.getByRole('button', { name: /export data/i }));
      
      expect(mockAuditLog).toHaveBeenCalledWith({
        userId: mockUser.id,
        action: 'data-export',
        timestamp: expect.any(Number),
        ip: expect.any(String),
        userAgent: expect.any(String)
      });
    });

    it('should log authentication failures', () => {
      const mockAuditLog = jest.fn();
      const invalidUser = { ...mockUser, password: 'wrong-password' };
      
      render(<${ComponentName} user={invalidUser} auditLog={mockAuditLog} />);
      
      expect(mockAuditLog).toHaveBeenCalledWith({
        event: 'auth-failure',
        userId: invalidUser.id,
        reason: 'invalid-credentials',
        timestamp: expect.any(Number)
      });
    });
  });
});