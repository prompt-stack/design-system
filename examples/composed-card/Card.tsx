/**
 * @layer composed
 * @description Container component with styled card appearance
 * @dependencies Box primitive
 * @cssFile /styles/components/card.css
 * @utilities spacing (via Box), shadow (via Box)
 * @variants ["default", "elevated", "outlined", "glass"]
 * @className .card
 * @status stable
 * @since 2025-07-19
 * @a11y Role and aria-label for interactive cards
 * 
 * Example of a composed component that uses Box for utilities
 * while maintaining its own CSS for unique styling.
 */

import { forwardRef } from 'react';
import clsx from 'clsx';
import type { ReactNode } from 'react';
import { Box } from '@/components/Box';
import type { BoxProps } from '@/components/Box';

interface CardProps extends Omit<BoxProps, 'className'> {
  children: ReactNode;
  selected?: boolean;
  interactive?: boolean;
  variant?: 'default' | 'elevated' | 'outlined' | 'glass';
  className?: string;
}

export const Card = forwardRef<HTMLDivElement, CardProps>(
  ({ 
    children, 
    selected, 
    interactive, 
    variant = 'default', 
    className,
    // Default utility props showing the pattern
    padding = '4',
    rounded = 'md',
    shadow = variant === 'elevated' ? 'md' : undefined,
    ...boxProps 
  }, ref) => {
    return (
      <Box 
        ref={ref}
        className={clsx(
          'card',
          `card--${variant}`,
          selected && 'card--selected',
          interactive && 'card--interactive',
          className
        )}
        data-selected={selected}
        // Utilities handled by Box
        padding={padding}
        rounded={rounded}
        shadow={shadow}
        // Interactive cards need proper roles
        role={interactive ? 'button' : undefined}
        tabIndex={interactive ? 0 : undefined}
        {...boxProps}
      >
        {children}
      </Box>
    );
  }
);

Card.displayName = 'Card';

// Export sub-components for better composition
export const CardHeader = ({ children, className, ...props }: BoxProps) => (
  <Box className={clsx('card__header', className)} {...props}>
    {children}
  </Box>
);

export const CardBody = ({ children, className, ...props }: BoxProps) => (
  <Box className={clsx('card__body', className)} {...props}>
    {children}
  </Box>
);

export const CardFooter = ({ children, className, ...props }: BoxProps) => (
  <Box className={clsx('card__footer', className)} {...props}>
    {children}
  </Box>
);