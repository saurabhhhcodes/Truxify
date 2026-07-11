import EventEmitter from 'events';

class EventBus extends EventEmitter {
  constructor() {
    super();
    // Increase limit if we have many subscribers to prevent memory leak warnings
    this.setMaxListeners(20);
  }

  /**
   * Safely emit an event, allowing subscribers to handle failures internally
   * @param {string} event 
   * @param  {...any} args 
   */
  emitSafe(event, ...args) {
    return this.emit(event, ...args);
  }
}

export const eventBus = new EventBus();
