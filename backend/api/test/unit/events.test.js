import { describe, it, expect, vi } from 'vitest';
import { eventBus } from '../../src/core/events.js';

describe('EventBus', () => {
  it('should emit and listen to events securely', () => {
    const listener = vi.fn();
    eventBus.on('test:event', listener);

    eventBus.emitSafe('test:event', { payload: 'data' });

    expect(listener).toHaveBeenCalledTimes(1);
    expect(listener).toHaveBeenCalledWith({ payload: 'data' });

    eventBus.off('test:event', listener);
  });
});
