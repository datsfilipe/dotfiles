declare module 'astal/file';
declare module 'astal/bind';
declare module 'astal/process';
declare module 'astal/gtk3';
declare module 'astal' {
  export interface Variable<T> {
    set: (value: T) => void;
    get: () => T;
    poll: (
      interval: number,
      callback: () => void,
    ) => {
      drop: () => void;
    };
  }

  export const Variable: {
    <T>(initial: T): Variable<T>;
    new <T>(initial: T): Variable<T>;
  };

  export const bind: any;
  export const exec: any;
  export const execAsync: any;
  export const timeout: any;
  export const interval: any;
  export const App: any;
  export const Widget: any;
  export const GLib: any;
}

declare module 'gi://GLib';
declare module 'gi://AstalTray';
declare module 'gi://AstalWp';
declare module 'gi://Pango';
