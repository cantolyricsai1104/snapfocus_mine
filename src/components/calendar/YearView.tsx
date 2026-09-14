import React from 'react';
import { TaskBlock } from '../../types';
import { formatDateToYMD, isTaskScheduledOnDate } from '../../utils/dateUtils';
import { Haptics } from '../../services/haptics';

interface YearViewProps {
  currentYear: number;
  onSelectMonth: (monthIndex: number) => void;
  onSelectDate: (date: Date) => void;
  tasks: TaskBlock[];
}

export const YearView: React.FC<YearViewProps> = ({
  currentYear,
  onSelectMonth,
  onSelectDate,
  tasks,
}) => {
  const today = new Date();
  const todayStr = formatDateToYMD(today);

  const monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  return (
    <div className="flex-1 flex flex-col h-full bg-[#0E0E11] text-white p-3 overflow-y-auto">
      {/* 3x4 Responsive Grid for 12 Months */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
        {monthNames.map((mName, mIdx) => {
          const daysInMonth = new Date(currentYear, mIdx + 1, 0).getDate();
          const firstDay = new Date(currentYear, mIdx, 1);
          const startDayOfWeek = (firstDay.getDay() + 6) % 7; // Mon=0, Sun=6

          // Calculate total tasks for this month
          let monthTaskCount = 0;
          const daysData: { day: number; dateStr: string; hasTask: boolean; isToday: boolean }[] = [];

          for (let d = 1; d <= daysInMonth; d++) {
            const dateObj = new Date(currentYear, mIdx, d);
            const dateStr = formatDateToYMD(dateObj);
            const isToday = dateStr === todayStr;
            const dayTasks = tasks.filter((t) => isTaskScheduledOnDate(t, dateStr));
            if (dayTasks.length > 0) {
              monthTaskCount += dayTasks.length;
            }
            daysData.push({
              day: d,
              dateStr,
              hasTask: dayTasks.length > 0,
              isToday,
            });
          }

          return (
            <div
              key={mName}
              className="bg-[#15151A] rounded-2xl p-3 border border-white/[0.08] hover:border-white/20 transition-all flex flex-col"
            >
              {/* Month Header */}
              <div
                onClick={() => {
                  onSelectMonth(mIdx);
                  Haptics.selectionAsync();
                }}
                className="flex items-center justify-between cursor-pointer hover:text-[#FF6B00] transition-colors pb-2 border-b border-white/[0.06]"
                title={`Open ${mName} Month View`}
              >
                <h3 className="font-bold text-sm text-neutral-100">{mName}</h3>
                {monthTaskCount > 0 ? (
                  <span className="text-[10px] font-mono font-semibold px-2 py-0.5 rounded-full bg-[#FF6B00]/15 text-[#FF6B00] border border-[#FF6B00]/30">
                    {monthTaskCount} {monthTaskCount === 1 ? 'task' : 'tasks'}
                  </span>
                ) : (
                  <span className="text-[10px] font-mono text-neutral-500">0 tasks</span>
                )}
              </div>

              {/* Day of Week initials */}
              <div className="grid grid-cols-7 gap-0.5 text-center my-1.5 text-[9px] font-bold text-neutral-500">
                <span>M</span>
                <span>T</span>
                <span>W</span>
                <span>T</span>
                <span>F</span>
                <span>S</span>
                <span>S</span>
              </div>

              {/* Days Mini Grid */}
              <div className="grid grid-cols-7 gap-0.5 text-center text-[10px] font-mono">
                {/* Empty padding for start of month */}
                {Array.from({ length: startDayOfWeek }).map((_, i) => (
                  <div key={`pad-${i}`} className="h-5" />
                ))}

                {daysData.map((d) => (
                  <button
                    key={d.day}
                    type="button"
                    onClick={() => {
                      onSelectDate(new Date(currentYear, mIdx, d.day));
                      Haptics.selectionAsync();
                    }}
                    className={`h-5 w-full rounded flex items-center justify-center relative transition-all ${
                      d.isToday
                        ? 'bg-[#FF6B00] text-black font-bold'
                        : d.hasTask
                        ? 'bg-white/15 text-white font-bold hover:bg-[#FF6B00]/40'
                        : 'text-neutral-400 hover:text-white hover:bg-white/5'
                    }`}
                    title={`${mName} ${d.day}: ${d.hasTask ? 'Has scheduled tasks' : 'Blank day'}`}
                  >
                    <span>{d.day}</span>
                    {d.hasTask && !d.isToday && (
                      <span className="absolute bottom-0.5 w-1 h-1 rounded-full bg-[#FF6B00]" />
                    )}
                  </button>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};
