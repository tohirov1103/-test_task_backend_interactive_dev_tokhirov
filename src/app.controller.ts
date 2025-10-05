import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHealth(): { message: string; timestamp: string } {
    return this.appService.getHealth();
  }

  @Get('health')
  getHealthCheck(): { status: string; timestamp: string } {
    return this.appService.getHealthCheck();
  }
}